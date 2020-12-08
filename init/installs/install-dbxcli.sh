#!/bin/bash

set -eu -o pipefail

curl -L -O https://github.com/dropbox/dbxcli/releases/latest/download/dbxcli-darwin-amd64

chmod +x dbxcli-darwin-amd64

mv dbxcli-darwin-amd64 ~/bin/dbxcli



