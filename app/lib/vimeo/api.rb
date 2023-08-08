class Vimeo::Api
  require 'net/http'
  require 'json'

  attr_reader :video_id
  def initialize(video_id)
    @video_id = video_id
  end

  def get_video_duration
    video_info = get_video_info
    # p JSON.generate(video_info)

    duration = video_info['duration']
    puts "この動画は#{duration}秒ある"
    duration
  end

  def get_video_info
    uri = Vimeo::Api.build_url(video_id)
    access_token = "674f2ffde1ddc1fda7d2cb5abced9994"

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"
  
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    JSON.parse(res.body)
  end

  private

    def self.build_url(video_id)
      URI("https://api.vimeo.com/videos/#{video_id}")
    end

end