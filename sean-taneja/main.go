package main

import (
	"context"
	"os"
	"strings"
	"sync"

	log "github.com/sirupsen/logrus"
	corev1 "k8s.io/api/core/v1"
	rbacv1 "k8s.io/api/rbac/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/watch"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/cache"
	"k8s.io/client-go/tools/clientcmd"
	toolsWatch "k8s.io/client-go/tools/watch"
)

var (
	config, _    = clientcmd.BuildConfigFromFlags("", os.Getenv("KUBECONFIG"))
	clientset, _ = kubernetes.NewForConfig(config)
)

// NamespaceWatcher watches for namespace events
type NamespaceWatcher struct {
	clientset kubernetes.Interface
}

// NewNamespaceWatcher creates a new instance of NamespaceWatcher
func NewNamespaceWatcher(clientset kubernetes.Interface) *NamespaceWatcher {
	return &NamespaceWatcher{clientset: clientset}
}

// WatchNamespaces starts watching for namespace events
func (nw *NamespaceWatcher) WatchNamespaces() {
	watchFunc := func(options metav1.ListOptions) (watch.Interface, error) {
		timeOut := int64(60)
		return nw.clientset.CoreV1().Namespaces().Watch(context.Background(), metav1.ListOptions{TimeoutSeconds: &timeOut})
	}

	watcher, _ := toolsWatch.NewRetryWatcher("1", &cache.ListWatch{WatchFunc: watchFunc})

	for event := range watcher.ResultChan() {
		item := event.Object.(*corev1.Namespace)

		switch event.Type {
		case watch.Modified:
		case watch.Bookmark:
		case watch.Error:
		case watch.Deleted:
		case watch.Added:
			nw.processNamespace(item.GetName())
		}
	}
}

func (nw *NamespaceWatcher) processNamespace(namespace string) {
	log.Infof("Processing newly created namespace: %s", namespace)

	// Check if the Role exists; if not, create it
	roleName := namespace + "-dev"
	_, err := nw.clientset.RbacV1().Roles(namespace).Get(context.Background(), roleName, metav1.GetOptions{})
	if err != nil {
		if !errors.IsNotFound(err) {
			log.Errorf("Failed to get Role %s in namespace %s: %v", roleName, namespace, err)
			return
		}
		// Role doesn't exist, create it
		nw.createRole(namespace, roleName)
	}

	userAccessConfig, err := getUserAccessConfig(nw.clientset, namespace)
	if err != nil {
		log.Errorf("Failed to fetch user access configuration: %v", err)
		return
	}

	for _, config := range userAccessConfig {
		if config.Namespace == namespace {
			nw.createRoleBinding(namespace, config.User)
		}
	}
}

func (nw *NamespaceWatcher) createRole(namespace, roleName string) {
	role := &rbacv1.Role{
		ObjectMeta: metav1.ObjectMeta{
			Name: roleName,
		},
		Rules: []rbacv1.PolicyRule{
			{
				APIGroups: []string{rbacv1.GroupName},
				Resources: []string{"*"}, // All resources
				Verbs:     []string{"*"}, // All verbs
			},
		},
	}

	_, err := nw.clientset.RbacV1().Roles(namespace).Create(context.Background(), role, metav1.CreateOptions{})
	if err != nil {
		log.Errorf("Failed to create Role %s in namespace %s: %v", roleName, namespace, err)
		return
	}

	log.Infof("Role %s created successfully in namespace %s", roleName, namespace)
}

func getUserAccessConfig(clientset kubernetes.Interface, namespace string) ([]UserAccessConfig, error) {
	cm, err := clientset.CoreV1().ConfigMaps("default").Get(context.Background(), "user-access-config", metav1.GetOptions{})
	if err != nil {
		return nil, err
	}

	var userAccessConfig []UserAccessConfig
	for user, data := range cm.Data {
		config := strings.Split(data, "\n")
		if len(config) != 2 {
			log.Warnf("Invalid user access configuration for user %s in ConfigMap", user)
			continue
		}
		userAccessConfig = append(userAccessConfig, UserAccessConfig{
			User:      user,
			Namespace: strings.TrimSpace(strings.Split(config[0], ":")[1]),
		})
	}

	return userAccessConfig, nil
}

func (nw *NamespaceWatcher) createRoleBinding(namespace, user string) {
	rb := &rbacv1.RoleBinding{
		ObjectMeta: metav1.ObjectMeta{
			Name: user + "-rolebinding",
		},
		RoleRef: rbacv1.RoleRef{
			APIGroup: rbacv1.GroupName,
			Kind:     "Role",
			Name:     namespace + "-dev",
		},
		Subjects: []rbacv1.Subject{
			{
				Kind:      "User",
				Name:      user,
				Namespace: namespace,
			},
		},
	}

	_, err := nw.clientset.RbacV1().RoleBindings(namespace).Create(context.Background(), rb, metav1.CreateOptions{})
	if err != nil {
		log.Errorf("Failed to create RoleBinding %s in namespace %s: %v", rb.Name, namespace, err)
		return
	}

	log.Infof("RoleBinding created successfully for user %s in namespace %s", user, namespace)
}

type UserAccessConfig struct {
	User      string
	Namespace string
}

func main() {
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalf("Error creating Kubernetes client: %v", err)
	}

	nw := NewNamespaceWatcher(clientset)
	var wg sync.WaitGroup
	go nw.WatchNamespaces()
	wg.Add(1)
	wg.Wait()
}
