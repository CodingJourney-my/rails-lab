require_relative "./openapi_task_runner"

class Openapi::Api
  TOKENS = {
    "default" => {
      authenticated_token: "eyJhbGciOiJIUzI1NiJ9.eyJ0d29fc3RlcF9hdXRoX2NvZGUiOjEsImlhdCI6MTczMTYzNzg1NiwiZXhwIjo0ODg1MjM3ODU2fQ.5Qu2Ang5lNp2-2rUZSRA_KtQSMzT_u2BFfVGhxCJp6E",
      authorized_token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VyX2VtYWlsIjoibWFzdGVyMUBleGFtcGxlLmNvbSIsInBlcm1pc3Npb24iOnsiYWJpbGl0eV9raW5kIjoibWFzdGVyIn0sImlhdCI6MTczMTYzODEzMiwiZXhwIjo0ODg1MjM4MTMyfQ.OdHwK0j3OslK8hqW5OCjNxOpzfy0bz8TGV6gmbHAIis",
    },
  }

  OPTIONS = {
    "default" => {
      # origin: 'https://api.staging.knowledgemixer.com',
      origin: 'http://127.0.0.1:3300',
      content_type: 'application/json',
    },
  }

  class << self
    def shared_parameters
      {
        authenticated_token: {
          name: "Authorization",
          in: "header",
          required: true,
          schema: {type: 'string'},
          description: "Authenticated Token",
          example: 'Bearer ',
        },
        authorized_token: {
          name: "Authorization",
          in: "header",
          required: true,
          schema: {type: 'string'},
          description: "Authorized Token",
          example: 'Bearer ',
        },
        id: {
          name: "id",
          schema: {type: 'integer'},
          example: 250,
        },
        slug: {name: "slug", in: "query", schema: {type: 'string'}, example: 'slug'},
        email: {name: "email", in: "query", schema: {type: 'string'}, example: 'user@example.com', description: 'ユーザーのメールアドレスを指定します。'},
        version: {name: "version", in: "query", schema: {type: 'integer'}, example: 1},
        key: {name: "key", in: "query", schema: {type: 'string'}, example: 'key'},

        offset: {name: "offset", in: "query", schema: {type: 'integer'}, example: 10},
        limit: {name: "limit", in: "query", schema: {type: 'integer'}, example: 30},
        sort_by: {name: "sort_by", in: "query", schema: {type: 'string'}, example: 'created_at_desc', description: 'ソート順を指定します。'},
        keyword: {name: "keyword", in: "query", schema: {type: 'string'}, example: ['キーワード'], description: 'キーワードを指定して全文検索による絞り込みを利用できます。'},
        channel: {name: "channel", in: "query", schema: {type: 'array', items: {type: 'string'}}, example: ['default'], description: 'チャンネルを指定します。配列形式で複数指定した場合、or検索となります。'},
        channels: {name: "channels", in: "query", schema: {type: 'array', items: {type: 'string'}}, example: ['default'], description: 'チャンネルを指定します。配列形式で複数指定した場合、or検索となります。'},
      }
    end
  end


  attr_reader :openapi
  def initialize(profile='default')
    @tokens = TOKENS[profile]
    @options = OPTIONS[profile]

    @openapi = Openapi::Generator.new({
      openapi: "3.0.3",
      info: {
        description: <<~EOS,
          ## 用語

          ### Business

          #### Resource

          ### API

          - `Authenticated Token`: `email` / `password` の認証を通過したことを示すトークン。ログイン成功時に払い出されます。
          - `Authorized Token`: リソースへのアクセス権を認可されたことを示すトークン。ログイン完了時に払い出され、APIや保護されたリソースへのアクセスに使用されます。

          ## エラーコード

          以下はapi全体的に返されることのあるエラーの一覧です。

          |http status|code|description|
          |----|----|----|
          |400|`input_invalid`|バリデーションエラーなど不正なデータ入力|
          |401|`unauthorized`|操作権限がありません|
          |401|`token_unauthorized`|トークン認証に失敗しました|
          |401|`token_expired`|トークンが期限切れです|
          |401|`verification_failed`|認証に失敗しました|
          |401|`verification_expired`|認証が期限切れです|
          |401|`verification_invalidated`|認証試行超過のため認証番号が無効化されました|
          |401|`authentication_failed`|認証に失敗しました|
          |401|`need_to_accept_new_terms_of_service`|規約が更新されました|
          |403|`authorization_violated`|認証情報が不正です|
          |404|`not_found`|データが存在しません|
          |500|`unknown_error`|バグなどエラーハンドリングされていない未定義エラーです|
          |503|`under_maintenance`|メンテナンス中です|
        EOS
        version: "1.0.0",
        title: "Test Api",
      },
      servers: [
        {
          url: "http://localhost:3000",
          description: "Test API",
        },
      ],
    })

    @notoken = Openapi::ApiClient::Runner.new(
      Openapi::ApiClient.new(
        **@options.merge(token: nil), common_headers: [],
      ),
      @openapi,
      shared_parameters: self.class.shared_parameters,
    )
    # API用
    @authenticatedtoken = Openapi::ApiClient::Runner.new(
      Openapi::ApiClient.new(
        **@options.merge(token: @tokens[:authenticated_token]),
        common_headers: []
      ),
      @openapi,
      shared_parameters: self.class.shared_parameters,
    )

    def run

    end

  end
  # End エンドポイント  ===========================================================================================

end
