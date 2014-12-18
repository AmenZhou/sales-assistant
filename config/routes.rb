Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :categories
  resources :posts
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
  end

  get 'posts_searches/by_tag', to: 'posts_searches#by_tag'
  get 'posts_searches/by_username', to: 'posts_searches#by_username'
  get 'posts_searches/by_media_type', to: 'posts_searches#by_media_type'
end
