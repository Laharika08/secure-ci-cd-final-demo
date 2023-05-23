package resources

import (
	"context"

	"github.com/alyragab/cq-source-vault/client"
	"github.com/alyragab/cq-source-vault/vault"
	"github.com/cloudquery/plugin-sdk/v2/schema"
)

// Transform Vault audit data
func VaultTable() *schema.Table {
	return &schema.Table{
		Name:     "vault",
		Resolver: fetchVaultAudit,
		Columns: []schema.Column{
			{
				Name:     "audit",
				Type:     schema.TypeString,
				Resolver: fetch,
			},
		},
	}
}

// fetchVaultAudit to send the record value into vault table
func fetchVaultAudit(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	c := meta.(*client.Client)
	res <- c.FileContent()
	return nil
}

// fetch to send the record value into column
func fetch(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	client := meta.(*client.Client)
	resource.Set(c.Name, client.FileContent())
	defer vault.TruncateAuditFile(vault.FilePath)
	return nil
}
