CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: Rails.application.secrets[:s3][:provider],
    aws_access_key_id: Rails.application.secrets[:s3][:aws_access_key_id],
    aws_secret_access_key: Rails.application.secrets[:s3][:aws_secret_access_key],
    region: Rails.application.secrets[:s3][:region]
  }
  config.fog_directory = "homestohotels"
end