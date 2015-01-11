Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :categories
  resources :posts, :sales_tools do
    collection do
      get 'by_tag/:tag', to: :by_tag, as: :by_tag
      get 'by_username/:username', to: :by_username, as: :by_username, :constraints => { :username => /[^\/]+/ }
      get 'by_media_type/:media_type', to: :by_media_type, as: :by_media_type
      get 'by_category/:category', to: :by_category, as: :by_category
      get 'by_quick_search', to: :by_quick_search, as: :by_quick_search
      get 'by_complex_search', to: :by_complex_search, as: :by_complex_search
    end
  end
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
  end

  namespace :mine do
    resource :profile, controller: :profile
  end
end
