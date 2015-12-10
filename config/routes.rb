Rails.application.routes.draw do


  root 'index/index#index'

  scope module: 'index' do
    resources :user,only:[:edit]
    #主页
    get '/' => 'index#index'
    #前台查询
    get '/search' => 'index#search', as: 'search'
    #通知公告
    get '/passage/:id' => 'passage#show', as: 'passage'

    get 'creations' => 'creation#index', as: 'creations'
    get 'creations/:id' => 'creation#show', as: 'creation'
    post 'creations/:id/vote' => 'creation#vote', as: 'creation_vote'
    delete 'creations/:id/vote' => 'creation#unvote'
    post 'creations/:id/comment' => 'creation#comment', as: 'creation_comment'
    #用户中心
    get 'usercenter' => 'usercenter#index'
    post 'usercenter/read_msg/:id' => 'usercenter#set_read_msg'  # 设置信息已读
    #用户注册
    get 'user/reg'
    post 'user/reg' => 'user#create'
    post 'user/reg/validate' =>'user#validate'
    #登陆控制
    get 'user/login'
    post 'user/login' => 'user#do_login'
    delete 'user/logout' => 'user#logout'

    get 'user/:name' => 'user#show', as: 'user_detail'
  end

  namespace :manage do
    get '/' => 'index#index'

    # 登录控制
    get 'login' => 'session#index'
    post 'login' => 'session#create'
    delete 'logout' => 'session#destroy'
    get 'vcode' => 'session#vcode'

    # 个人信息修改
    get 'admins/edit_self'
    post 'admins/edit_self' => 'admins#update_self'

    # 管理员
    resources :admins

    # 通知公告
    resources :posts
    # 用户
    resources :users
    get 'users/:id/message' => 'messages#new', as: 'send_message'
    post 'users/message' => 'messages#create', as: 'post_message'
    # 作品
    resources :creations, only: [:index, :edit, :update, :show, :destroy]
    # 评审
    resources :judges, only: [:index, :update, :show, :create]

    get 'comments' => 'comment#index'
    get 'comment/:id' => 'comment#show'
    patch 'comment/:id' => 'comment#update'
    delete 'comment/:id' => 'comment#destroy'

    get 'cfgs' => 'cfg#index'
    get 'cfg/exp_video' => 'cfg#exp_video'
    delete 'cfg/:id' => 'cfg#delete_video', as: 'delete_video'
    get 'cfg/:id/screenshot' => 'cfg#screenshot'
    post 'cfg/exp_video' => 'cfg#upload_video'
    patch 'cfg/:id' => 'cfg#update'

    #新建/更新/删除角色
    get 'roles/:id' => 'admins#show_role'
    post 'roles' => 'admins#create_role'
    get 'roles/:id/permission' => 'admins#edit_role'
    patch 'roles/:id' => 'admins#update_role'
    delete 'roles/:id' => 'admins#destroy_role'
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
