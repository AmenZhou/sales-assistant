# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.destroy_all

['產品介紹', 'Presentation Proposal', '價格', '郵件範圍', '廣告範圍', '客戶反饋', '工作流程', '其他'].each do |category|
  SalestoolCategory.create(name: category)
end

['SourthEast', 'Chinese', 'Mexican', 'European', 'American'].each do |country|
  GlobalfoodCategory.create(name: country)
end

['2014', '2015'].each do |year|
  MeetingrecordCategory.create(name: year)
end

User.destroy_all
User.create(email: 'user1@test.com', password: 'password', password_confirmation: 'password')
User.create(email: 'user2@test.com', password: 'password', password_confirmation: 'password')

Post.destroy_all
tags = Faker::Lorem.words(10)

puts 'create posts'
50.times.each do
  print '.'
  post = SalesTool.create!(user_id: User.pluck(:id).sample, title: Faker::Lorem.word, content: Faker::Lorem.sentence, category_id: Category.where(type: 'SalesTool').pluck(:id).sample,  media_type: Post::MediaType.sample, tag_list: tags.sample)
  post.upload_files.create!(remote_image_url: 'http://epoch-152230.use1-2.nitrousbox.com/assets/logo.png')
end

%w( Expshare Activity Globalfood Meetingrecord Evaluation ).each do |klass|
  50.times.each do
    print '.'
    post_klass = klass + 'Post'
    categ_klass = klass + 'Category'
    post = post_klass.constantize.create!(user_id: User.pluck(:id).sample, title: Faker::Lorem.word, content: Faker::Lorem.sentence, category_id: Category.where(type: categ_klass).pluck(:id).sample, tag_list: tags.sample)
    post.upload_files.create!(remote_image_url: 'http://epoch-152230.use1-2.nitrousbox.com/assets/logo.png')
  end
end
