package main

import (
	"github.com/alyragab/cq-source-vault/plugin"
	"github.com/cloudquery/plugin-sdk/v2/serve"
)

func main() {
	serve.Source(plugin.Plugin())
}
