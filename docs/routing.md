# ルーティング構造

## トップページ
- ルート (`/`): `events#index` - イベント一覧ページがトップページとして設定されています

## イベント関連
- イベント一覧: `GET /events` (`events#index`)
- イベント詳細: `GET /events/:id` (`events#show`)
- イベント作成フォーム: `GET /events/new` (`events#new`)
- イベント編集フォーム: `GET /events/:id/edit` (`events#edit`)
- イベント作成処理: `POST /events` (`events#create`)
- イベント更新処理: `PATCH/PUT /events/:id` (`events#update`)
- イベント削除処理: `DELETE /events/:id` (`events#destroy`)
- カスタムイベントURL: `GET /e/:url_hash` (`events#show`) - ハッシュURLでのイベント表示

## 日程オプション関連（イベントにネスト）
- 日程オプション作成: `POST /events/:event_id/date_options` (`date_options#create`)
- 日程オプション削除: `DELETE /events/:event_id/date_options/:id` (`date_options#destroy`)

## 参加者関連（イベントにネスト）
- 参加者作成: `POST /events/:event_id/participants` (`participants#create`)

## アイテム関連（イベントにネスト）
- アイテム作成: `POST /events/:event_id/items` (`items#create`)
- アイテム更新: `PATCH/PUT /events/:event_id/items/:id` (`items#update`)
- アイテム削除: `DELETE /events/:event_id/items/:id` (`items#destroy`)

## 費用関連（イベントにネスト）
- 費用作成: `POST /events/:event_id/expenses` (`expenses#create`)
- 費用更新: `PATCH/PUT /events/:event_id/expenses/:id` (`expenses#update`)
- 費用削除: `DELETE /events/:event_id/expenses/:id` (`expenses#destroy`)

## 出欠関連
- 出欠作成: `POST /attendances` (`attendances#create`)
- 出欠更新: `PATCH/PUT /attendances/:id` (`attendances#update`)

## レーシングカレンダー関連
- カレンダー表示: `GET /racing_calendar` (`racing_calendar#index`)

## その他
- ヘルスチェック: `GET /up` (`rails/health#show`)

## 主な画面遷移フロー
1. トップページ（イベント一覧）から各イベントの詳細ページへ遷移
2. イベント詳細ページでは:
   - 日程オプションの追加・削除
   - 参加者の追加
   - アイテムの追加・更新・削除
   - 費用の追加・更新・削除 が可能
3. 出欠回答はイベントとは別のルーティングになっており、作成と更新が可能
4. レーシングカレンダーは独立した機能として表示可能
