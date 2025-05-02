# keiba-concierge
  - 競馬幹事コンシェルジュは、競馬観戦イベントの幹事業務を円滑にするアプリケーションです。 
  - 日程調整、持ち物管理、費用精算まで、簡単に管理できます。

## 目的
  - 仲間と楽しく競馬場に行きたい
  - 幹事が競馬イベントの準備から精算までを一貫して行える


## セットアップ

1. ソースコードをcloneして、リポジトリの配下に移動

    ```shell
    git clone git@github.com:kotakky77/keiba-concierge.git
    cd keiba-concierge.git
    ````

1. dockerイメージをビルド

    初回のビルドは数分かかる

    ```shell
    docker compose build
    ```

1. DBをセットアップ

    初回の実行はdockerイメージのダウンロードが必要なため、数分かかる

    ```shell
    
    ```

2. 下記コマンドを実行し、dockerを起動する

    ```shell
    docker compose up -d
    ```

3. 起動後の動作確認
    - ブラウザで http://localhost:3000 にアクセスしてログイン画面が表示されることを確認