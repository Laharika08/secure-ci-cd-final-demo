package main

import (
	"context"
	"testing"

	log "github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes/fake"
)

func TestCreateRole(t *testing.T) {
	namespace := "test-namespace"
	roleName := "test-role"

	// Create a fake clientset
	clientset := fake.NewSimpleClientset()

	// Create the test namespace
	createTestNamespace(clientset, namespace)

	// Create a NamespaceWatcher instance
	nw := NewNamespaceWatcher(clientset)

	// Call the createRole function
	nw.createRole(namespace, roleName)

	// Retrieve the created role
	role, err := clientset.RbacV1().Roles(namespace).Get(context.Background(), roleName, v1.GetOptions{})
	// Assert that there's no error and the role exists
	assert.NoError(t, err)
	assert.NotNil(t, role)
	assert.Equal(t, roleName, role.Name)
	assert.Len(t, role.Rules, 1)

	// Delete the test namespace
	deleteTestNamespace(clientset, namespace)
}

func TestCreateRoleBinding(t *testing.T) {
	namespace := "test-namespace"
	user := "test-user"

	// Create a fake clientset
	clientset := fake.NewSimpleClientset()

	// Create the test namespace
	createTestNamespace(clientset, namespace)

	// Create a NamespaceWatcher instance
	nw := NewNamespaceWatcher(clientset)

	// Call the createRoleBinding function
	nw.createRoleBinding(namespace, user)

	// Retrieve the created role binding
	roleBinding, err := clientset.RbacV1().RoleBindings(namespace).Get(context.Background(), user+"-rolebinding", v1.GetOptions{})
	assert.NoError(t, err)
	assert.NotNil(t, roleBinding)
	assert.Equal(t, user+"-rolebinding", roleBinding.Name)
	assert.Equal(t, "Role", roleBinding.RoleRef.Kind)
	assert.Equal(t, namespace+"-dev", roleBinding.RoleRef.Name)
	assert.Len(t, roleBinding.Subjects, 1)
	assert.Equal(t, "User", roleBinding.Subjects[0].Kind)
	assert.Equal(t, user, roleBinding.Subjects[0].Name)
	assert.Equal(t, namespace, roleBinding.Subjects[0].Namespace)

	// Delete the test namespace
	deleteTestNamespace(clientset, namespace)
}

func TestProcessNamespace(t *testing.T) {
	namespace := "test-namespace"

	// Create a fake clientset
	clientset := fake.NewSimpleClientset()

	// Create the test namespace
	createTestNamespace(clientset, namespace)

	// Create a ConfigMap with user access configuration
	clientset.CoreV1().ConfigMaps("default").Create(context.Background(), &corev1.ConfigMap{
		ObjectMeta: v1.ObjectMeta{Name: "user-access-config"},
		Data: map[string]string{
			"user1@tenant1.com": "namespace: test-namespace\nrole: admin",
		},
	}, v1.CreateOptions{})

	// Create a NamespaceWatcher instance
	nw := NewNamespaceWatcher(clientset)

	// Call the processNamespace function with the correct arguments
	nw.processNamespace(namespace)

	// Retrieve the created role
	role, err := clientset.RbacV1().Roles(namespace).Get(context.Background(), namespace+"-dev", v1.GetOptions{})
	assert.NoError(t, err)
	assert.NotNil(t, role)
	assert.Len(t, role.Rules, 1)

	// Retrieve the created role binding
	roleBinding, err := clientset.RbacV1().RoleBindings(namespace).Get(context.Background(), "user1@tenant1.com-rolebinding", v1.GetOptions{})
	assert.NoError(t, err)
	assert.NotNil(t, roleBinding)
	assert.Len(t, roleBinding.Subjects, 1)
	assert.Equal(t, "User", roleBinding.Subjects[0].Kind)
	assert.Equal(t, "user1@tenant1.com", roleBinding.Subjects[0].Name)
	assert.Equal(t, namespace, roleBinding.Subjects[0].Namespace)

	// Delete the test namespace
	deleteTestNamespace(clientset, namespace)
}

func createTestNamespace(clientset *fake.Clientset, namespace string) {
	_, err := clientset.CoreV1().Namespaces().Create(context.Background(), &corev1.Namespace{
		ObjectMeta: v1.ObjectMeta{Name: namespace},
	}, v1.CreateOptions{})
	if err != nil {
		log.Errorf("Error creating namespace %s: %v", namespace, err)
	} else {
		log.Infof("Namespace %s created successfully", namespace)
	}
}

func deleteTestNamespace(clientset *fake.Clientset, namespace string) {
	clientset.CoreV1().Namespaces().Delete(context.Background(), namespace, v1.DeleteOptions{})
}
