#!/bin/bash
set -e

# Rails固有のトラブルシューティング
rm -f /app/tmp/pids/server.pid

# コンテナのプロセスを実行（これは渡されたコマンドを実行）
exec "$@"