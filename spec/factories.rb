FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation '12345678'
  end
  factory :upload_file do
    image File.open(File.join(Rails.root, '/spec/factories/download.jpg'))
  end
end
