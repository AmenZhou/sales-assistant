if Rails.env.test? or Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  #CarrierWave.configure do |config|
    #config.storage = :fog
    #config.fog_credentials = {
      #:provider                         => 'Google',
      #:google_storage_access_key_id     => ENV['GOOGLE_STORAGE_PUBLIC_KEY'],
      #:google_storage_secret_access_key => ENV['GOOGLE_STORAGE_SECRET_KEY'],
    #}
    #config.fog_directory = 'sa_storage'
  #end
  CarrierWave.configure do |config|
    config.storage = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['S3_ACCESS_KEY'],                        # required
      aws_secret_access_key: ENV['S3_SCRET_KEY'],
      #region:                'US Standard',                  # optional, defaults to 'us-east-1'
      #host:                  's3.example.com',             # optional, defaults to nil
      #endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = 'sales-assistant'                          # required
    #config.fog_public     = false                                        # optional, defaults to true
    #config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
