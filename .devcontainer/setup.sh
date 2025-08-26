#!/usr/bin/env bash
set -e

CODEQL_VERSION="v2.22.4" # check for latest release
curl -sL "https://github.com/github/codeql-cli-binaries/releases/download/${CODEQL_VERSION}/codeql-linux64.zip" -o /tmp/codeql.zip
unzip -q /tmp/codeql.zip -d /usr/local/
ln -s /usr/local/codeql/codeql /usr/local/bin/codeql
rm /tmp/codeql.zip
