# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

Category.destroy_all

['產品介紹', 'Presentation', 'Proposal', '價格', '郵件範例', '廣告範例', '客戶反饋', '工作流程', '其他'].each do |category|
  SalestoolCategory.create(name: category)
end

['2014', '2015'].each do |year|
  MeetingrecordCategory.create(name: year)
end

['展覽會', '行業會議', '行業協會', '政府部門'].each do |activity|
  ActivityCategory.create(name: activity)
end

%w(中國 韓國 日本 越南 印度 法國 意大利 德國 西班牙 希臘 土耳其 墨西哥 美國 阿拉伯 猶太人 素食).each do |country|
  GlobalfoodCategory.create(name: country)
end

%w(成功案例 經驗教訓 新鮮點子 市場動態 客戶反饋).each do |expshare|
  ExpshareCategory.create(name: expshare)
end

User.destroy_all
User.create(email: 'user1@test.com', password: 'password', password_confirmation: 'password', username: 'user1')
User.create(email: 'user2@test.com', password: 'password', password_confirmation: 'password', username: 'user2')

Post.destroy_all
tags = Faker::Lorem.words(10)

puts 'create posts'
5.times.each do
  print '.'
  post = SalesTool.create!(user_id: User.pluck(:id).sample, title: Faker::Lorem.word, content: Faker::Lorem.sentence, category_id: Category.where(type: 'SalestoolCategory').pluck(:id).sample,  media_type: Post::MediaType.sample, tag_list: tags.sample)
  post.upload_files.create!(image: File.open(File.join(Rails.root, 'app', 'assets', 'images', 'logo.png')))
end

%w( Expshare Activity Globalfood Meetingrecord Evaluation ).each do |klass|
  5.times.each do
    print '.'
    post_klass = klass + 'Post'
    categ_klass = klass + 'Category'
    post = post_klass.constantize.create!(user_id: User.pluck(:id).sample, title: Faker::Lorem.word, content: Faker::Lorem.sentence, category_id: Category.where(type: categ_klass).pluck(:id).sample, tag_list: tags.sample)
    post.upload_files.create!(image: File.open(File.join(Rails.root, 'app', 'assets', 'images', 'logo.png')))
  end
end
