CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['S3_ACCESS_KEY'],                        # required unless using use_iam_profile
      aws_secret_access_key: ENV['S3_SECRET_KEY'],                        # required unless using use_iam_profile
      use_iam_profile:       false,                        # optional, defaults to false
      region:                'ap-northeast-2',             # optional, defaults to 'us-east-1'
      host:                  nil,                          # optional, defaults to nil
      endpoint:              nil                           # optional, defaults to nil
    }
    config.fog_directory  = ENV['S3_BUCKET']                                      # required
    config.fog_public     = false                          # private uploads
    config.fog_attributes = {} # optional, defaults to {}
    config.storage        = :fog # must come after fog_credentials
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :file
  end
end
