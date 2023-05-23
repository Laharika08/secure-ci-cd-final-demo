# CloudQuery vault Source Plugin
Shipping HashiCorp/Vault Audit Logs to CloudQuery PostgreSQL

[![test](https://github.com/alyragab/cq-source-vault/actions/workflows/test.yaml/badge.svg)](https://github.com/alyragab/cq-source-vault/actions/workflows/test.yaml)
[![Go Report Card](https://goreportcard.com/badge/github.com/alyragab/cq-source-vault)](https://goreportcard.com/report/github.com/alyragab/cq-source-vault)

A vault source plugin for CloudQuery that loads data from vault to any database, data warehouse or data lake supported by [CloudQuery](https://www.cloudquery.io/), such as PostgreSQL, BigQuery, Athena, and many more.

## How it works ?

It Gets Hashicorp/Vault Audit data from its local file (as audit file device) and Transforms it into any supported Destination (Postgres, SQLite, ES ...etc)

It then truncates the content of that local file in order to keep it away from getting fully utilized

It can be executed using the below commands:

```bash
go build -o cq-source-CloudQuery-Vault main.go
cloudquery sync config.yaml
```

Check the database 

```bash
sqlite ./sqlite.sql
.schema # Returns information related to the schema in SQLite
select * from vault;
```

## Links

 - [CloudQuery Quickstart Guide](https://www.cloudquery.io/docs/quickstart)
 - [Supported Tables](docs/tables/README.md)


## Configuration

The following source configuration file will sync to a PostgreSQL database. See [the CloudQuery Quickstart](https://www.cloudquery.io/docs/quickstart) for more information on how to configure the source and destination.

```yaml
kind: source
spec:
  name: "vault"
  path: "alyragab/vault"
  version: "${VERSION}"
  destinations:
    - "postgresql"
  spec:
    # plugin spec section
```

## Development

### Run tests

```bash
make test
```

### Run linter

```bash
make lint
```

### Release a new version

1. Run `git tag v1.0.0` to create a new tag for the release (replace `v1.0.0` with the new version number)
2. Run `git push origin v1.0.0` to push the tag to GitHub  

Once the tag is pushed, a new GitHub Actions workflow will be triggered to build the release binaries and create the new release on GitHub.
To customize the release notes, see the Go releaser [changelog configuration docs](https://goreleaser.com/customization/changelog/#changelog).
