FactoryGirl.define do
  factory :user do
    email "user@test.com"
    password '12345678'
    password_confirmation '12345678'
  end
  factory :upload_file do
    image File.open(File.join(Rails.root, '/spec/factories/download.jpg'))
  end
  factory :category do
    name "Meeting Records"
  end
  factory :sales_tool do
    title 'Title'
    content 'Content'
    media_type 'EET'
    user_id '1'
    tag_list 'cat, dog'
    after(:create) do |st|
      st.category = create(:category)
      st.upload_files << create(:upload_file)
      st.save
    end
  end
end
