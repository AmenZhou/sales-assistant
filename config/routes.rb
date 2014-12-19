Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :categories
  resources :posts do
    collection do
      get 'by_tag/:tag', to: :by_tag, as: :by_tag
      get 'by_username/:username', to: :by_username, as: :by_username, :constraints => { :username => /[^\/]+/ }
      get 'by_media_type/:media_type', to: :by_media_type, as: :by_media_type
    end
  end
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
  end
end
