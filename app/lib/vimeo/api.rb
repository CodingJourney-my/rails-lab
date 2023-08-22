class Vimeo::Api
  require 'net/http'
  require 'json'

  attr_reader :video_id
  def initialize(video_id)
    @video_id = video_id
  end

  def get_video_duration
    uri = Vimeo::Api.build_url("/videos/#{video_id}?fields=duration")
    res = request_execute(uri)
    res["duration"]
  end

  def request_execute(uri)
    access_token = "674f2ffde1ddc1fda7d2cb5abced9994"

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

    # X-RateLimit-Limit: 一定の時間枠（たとえば、1時間）内に許可される最大リクエスト数。
    puts "X-RateLimit-Limit: #{res['X-RateLimit-Limit']}"
    # X-RateLimit-Remaining: 現在の時間枠内で残っているリクエスト数。
    puts "X-RateLimit-Remaining: #{res['X-RateLimit-Remaining']}"
    # X-RateLimit-Reset: レート制限がリセットされる時刻。これは通常、Unixタイムスタンプ形式で提供されます。
    puts "X-RateLimit-Reset: #{res['X-RateLimit-Reset']}"
    JSON.parse(res.body)
  end

  private

    def self.build_url(path)
      URI("https://api.vimeo.com#{path}")
    end

end