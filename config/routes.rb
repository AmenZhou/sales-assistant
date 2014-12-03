Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :categories do
    resources :posts
  end
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
  end
end
