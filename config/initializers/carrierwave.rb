if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => 'AKIAJYQVFM5L5ADVB22A',
      :aws_secret_access_key => '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'
    }
    config.fog_directory     =  'igold'
  end
end