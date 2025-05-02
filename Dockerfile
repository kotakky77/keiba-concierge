FROM ruby:3.4.2-slim

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libsqlite3-dev \
                       nodejs \
                       libpq-dev \
                       libyaml-dev

# アプリケーションディレクトリを作成
WORKDIR /app

# Railsのインストール
RUN gem install rails -v 8.0.2

# GemfileとGemfile.lockをコピー
COPY Gemfile* ./

# Gemfileに記載されたgemをインストール
RUN if [ -f Gemfile ]; then bundle install; fi

# アプリケーションコードをコピー
COPY . .

# エントリーポイントスクリプトをコピー
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
