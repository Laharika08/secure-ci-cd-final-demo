package client

import (
	"context"
	"fmt"

	"alyragab/cq-source-vault/vault"

	"github.com/cloudquery/plugin-pb-go/specs"
	"github.com/cloudquery/plugin-sdk/v2/plugins/source"
	"github.com/cloudquery/plugin-sdk/v2/schema"
	"github.com/rs/zerolog"
)

type Client struct {
	Logger zerolog.Logger
}

func (c *Client) ID() string {
	return "ID"
}

func (c *Client) FileContent() string {
	audit := vault.AuditData{}
	audit.AuditFileCheck()
	return audit.AuditContent
}

func New(ctx context.Context, logger zerolog.Logger, s specs.Source, opts source.Options) (schema.ClientMeta, error) {
	var pluginSpec Spec

	if err := s.UnmarshalSpec(&pluginSpec); err != nil {
		return nil, fmt.Errorf("failed to unmarshal plugin spec: %w", err)
	}
	// TODO: Add your client initialization here

	return &Client{
		Logger: logger,
	}, nil
}
