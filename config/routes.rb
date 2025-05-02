Rails.application.routes.draw do
  get "racing_calendar/index"
  # トップページはイベント一覧ページに設定
  root "events#index"

  # イベントに関連するルート
  resources :events do
    # イベントに関連する他のリソース
    resources :date_options, only: [:create, :destroy]
    resources :participants, only: [:create]
    resources :items, only: [:create, :update, :destroy]
    resources :expenses, only: [:create, :update, :destroy]
  end

  # 出欠回答に関するルート
  resources :attendances, only: [:create, :update]

  # イベントURL（ハッシュ）を使ったアクセスのためのカスタムルート
  get "e/:url_hash", to: "events#show", as: :event_by_hash

  # スタンダードなヘルスチェックエンドポイント
  get "up" => "rails/health#show", as: :rails_health_check

  # JRAレーシングカレンダー表示用のルート
  get "racing_calendar", to: "racing_calendar#index"
end
