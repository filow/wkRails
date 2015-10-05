Rails.application.routes.draw do


  root 'index/index#index'

  scope module: 'index' do
    get '/' => 'index#index'
  end

  namespace :manage do
    get '/' => 'index#index'

    # 登录控制
    get 'login' => 'session#index'
    post 'login' => 'session#create'
    delete 'logout' => 'session#destroy'
    get 'vcode' => 'session#vcode'

    # 管理员
    resources :admins
    # 通知公告
    resources :posts
    get 'posts/query/valid' => 'posts#valid'
    get 'posts/query/top' => 'posts#top'
    get 'posts/query/hide' => 'posts#hide'
    get 'posts/query/not_hide' => 'posts#not_hide'
    # 用户
    resources :users
  end

  # ckeditor需要的目录
  mount Ckeditor::Engine => '/ckeditor'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
