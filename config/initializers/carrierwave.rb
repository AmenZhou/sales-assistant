if Rails.env.test? or Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider                         => 'Google',
      :google_storage_access_key_id     => ENV['GOOGLE_STORAGE_PUBLIC_KEY'],
      :google_storage_secret_access_key => ENV['GOOGLE_STORAGE_SECRET_KEY'],
    }
    config.fog_directory = 'sa_storage'
  end
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
