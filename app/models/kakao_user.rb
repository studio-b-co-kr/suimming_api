# gets kakao user info
class KakaoUser
  attr_reader :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  # returns
  #{:id=>abcdefg,
  # :properties=>
  #  {:nickname=>"joe",
  #   :profile_image=>
  #    "http://k.kakaocdn.net/dn/4AQh0/blah/blah/profile_640x640s.jpg",
  #   :thumbnail_image=>
  #    "http://k.kakaocdn.net/dn/4AQh0/blah/blah/profile_110x110c.jpg"},
  # :kakao_account=>
  #  {:profile_needs_agreement=>false,
  #   :profile=>
  #    {:nickname=>"조",
  #     :thumbnail_image_url=>
  #      "http://k.kakaocdn.net/dn/bETtGi/blah/blah/img_110x110.jpg",
  #     :profile_image_url=>
  #      "http://k.kakaocdn.net/dn/bETtGi/blah/blah/img_640x640.jpg"},
  #   :has_email=>true,
  #   :email_needs_agreement=>false,
  #   :is_email_valid=>true,
  #   :is_email_verified=>true,
  #   :email=>"joe@gmail.com"}}
  def profile
    kakao_api_url = 'https://kapi.kakao.com/v2/user/me'.freeze
    kakao_api_key = "Bearer #{access_token}".freeze
    response = HTTP.auth(kakao_api_key)
                   .get(kakao_api_url)
    return nil unless response.status.success?

    response.parse.with_indifferent_access
  end
end
