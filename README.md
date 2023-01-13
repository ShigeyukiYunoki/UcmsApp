# UcmsApp

潰瘍性大腸炎患者のための相互支援SNSです。
9割の患者さんが軽症・中等症を占める指定難病の潰瘍性大腸炎。
<br>炎症を抑え、寛解状態を維持するには、毎日の服薬が欠かせません。
<br>そこで毎日の通知により、薬の飲み忘れを防ぎ、習慣化をお手伝いします。
<br>また、同じ苦しみを持つ人との情報交換や気持ちの共有により、
希望をもって生きられることを目的としています。

レスポンシブ対応なので、スマホでも見られます。

~~https://www.ucmsapp.com~~

## https://ucmsapp.fly.dev  AWS無料期間終了のため、fly.ioに移行しました

<img width="1256" alt="スクリーンショット 2021-11-07 17 11 20" src="https://user-images.githubusercontent.com/42525646/140637463-6039ecd2-efea-4f18-9b64-837c066630b7.png">

# 使用技術

- Ruby 2.7.1
- RubyonRails 6.0.4.1
- PostgreSQL 12
- Nginx 1.21.3
- Puma 4.3.8
- AWS  AWS無料期間終了のため、fly.ioに移行しました
  - VPC
  - EC2
  - RDS
  - Route53
  - ALB
  - Certificate Manager
  - S3  fly.ioと接続できず、投稿画像表示できない状態です
  - Amazon Simple Email Service  fly.ioと接続できず、メール受信できない状態です
- Rspec
- Rubocop
- Git/GitHub
- Docker/Docker-compose
- CircleCi CI/CD
- Capistrano3
- OneSignal
- 楽天商品検索 API
- simple_calendar
- SweetAlert
- Swiper

# 機能一覧
- ユーザー登録・ログイン機能
- 服薬アラート機能(SweetAlert,gon)
- 服薬プッシュ通知機能(OneSignal)
- 画像検索機能（rakuten_web_service）
- フォロー機能（Ajax)
- いいね！機能（Ajax)
- コメント機能
- カレンダーで服薬記録・投稿が確認できる機能（simple_calendar)
- ユーザー検索機能（ransack)
- ページネーション機能（kaminari)

# インフラ・AWS構成図
![UcmsApp_AWS構成図](https://user-images.githubusercontent.com/42525646/140727040-3af8d701-4abf-4f03-9454-7193e9f5e78e.png)

GitHubへのpush時に、CircleCIでRspecとRubocopが走ります。<br>
それが成功すると、masterブランチの場合、capistranoでEC2にdeployされます。

# ER図
![UcmsAppER](https://user-images.githubusercontent.com/42525646/140727138-a4220d8e-ef0e-4220-bf45-53bd565008dc.png)

# 今後やりたいこと
- ReactNativeでのネイティブアプリ化 → AppStoreにて公開中です！https://apple.co/3DyEoEO
- Terraformでのインフラのコード化
- React・Next.jsでのフロントエンド実装
