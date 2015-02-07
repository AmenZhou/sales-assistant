Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :categories
  resources :posts, :sales_tools, :expshare_posts, :activity_posts, :globalfood_posts, :meetingrecord_posts, :evaluation_posts do
    collection do
      get 'by_tag/:tag', action: :by_tag, as: :by_tag
      get 'clear', action: :clear_search
      get 'by_username/:username', action: :by_username, as: :by_username, :constraints => { :username => /[^\/]+/ }
      get 'by_media_type/:media_type', action: :by_media_type, as: :by_media_type
      get 'by_category/:category', action: :by_category, as: :by_category
      get 'by_quick_search', action: :by_quick_search, as: :by_quick_search
      get 'by_complex_search', action: :by_complex_search, as: :by_complex_search
    end
  end
  resources :upload_files do
    post :create, on: :collection, :defaults => { :format => 'js' }
    get :download_file, on: :member
  end

  namespace :mine do
    resource :profile, controller: :profile
  end
end
