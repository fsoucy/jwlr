CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: 'AKIAJYQVFM5L5ADVB22A',
        aws_secret_access_key: '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'
    }

    config.fog_directory  = 'igold'
    config.fog_public     = false
end