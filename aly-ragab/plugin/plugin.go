package plugin

import (
	"github.com/alyragab/cq-source-vault/client"
	"github.com/alyragab/cq-source-vault/resources"
	"github.com/cloudquery/plugin-sdk/v2/plugins/source"
	"github.com/cloudquery/plugin-sdk/v2/schema"
)

var (
	Version = "development"
)

func Plugin() *source.Plugin {
	return source.NewPlugin(
		"vault",
		Version,
		schema.Tables{
			resources.VaultTable(),
		},
		client.New,
	)
}
