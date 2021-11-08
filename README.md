# UcmsApp

潰瘍性大腸炎患者のための相互支援 SNS です。
9 割の患者さんが軽症・中等症を占める指定難病である潰瘍性大腸炎。
炎症を抑え、寛解状態を維持するには、毎日の服薬が欠かせません。
そこで毎日の通知により、薬の飲み忘れを防ぎ、習慣化をお手伝いします。
また、同じ苦しみを持つ人との情報交換や気持ちの共有により、
希望をもって生きられることを目的としています。

レスポンシブ対応ですが、基本的にはスマホメインです。

<img width="1256" alt="スクリーンショット 2021-11-07 17 11 20" src="https://user-images.githubusercontent.com/42525646/140637463-6039ecd2-efea-4f18-9b64-837c066630b7.png">

# 使用技術・機能一覧

- Ruby 2.7.1
- RubyonRails 6.0.4.1
- PostgreSQL 12
- Nginx 1.21.3
- Puma 4.3.8
- AWS
  - VPC
  - EC2
  - RDS
  - S3
  - Route53
  - ALB
  - Certificate Manager
  - Amazon Simple Email Service
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

![UcmsApp_AWS構成図](https://user-images.githubusercontent.com/42525646/140727040-3af8d701-4abf-4f03-9454-7193e9f5e78e.png)

GitHub への push 時に、CircleCI で Rspec と Rubocop が走ります。
それが成功すると master ブランチの場合、capistrano で EC2 に deploy されます。

![UcmsAppER](https://user-images.githubusercontent.com/42525646/140727138-a4220d8e-ef0e-4220-bf45-53bd565008dc.png)
