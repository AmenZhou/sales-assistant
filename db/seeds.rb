# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.destroy_all
Category.create(name: '產品介紹')
Category.create(name: 'Presentation')
Category.create(name: 'Proposal')
Category.create(name: '價格')
Category.create(name: '郵件範圍')
Category.create(name: '廣告範圍')
Category.create(name: '客戶反饋')
Category.create(name: '工作流程')
Category.create(name: '其他')

User.destroy_all
User.create(email: 'user1@test.com', password: 'password', password_confirmation: 'password')
User.create(email: 'user2@test.com', password: 'password', password_confirmation: 'password')

Post.destroy_all
tags = Faker::Lorem.words(10)

puts 'create posts'
50.times.each do
  print '.'
  post = SalesTool.create!(user_id: User.pluck(:id).sample, title: Faker::Lorem.word, content: Faker::Lorem.sentence, category_id: Category.pluck(:id).sample,  media_type: Post::MediaType.sample, tag_list: tags.sample)
  post.upload_files.create!(remote_image_url: 'http://epoch-152230.use1-2.nitrousbox.com/assets/logo.png')
end

