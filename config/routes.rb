Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :categories
  resources :posts do
    collection do
      get :by_tag
      get :by_username
      get :by_media_type
    end
  end
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
  end
end
