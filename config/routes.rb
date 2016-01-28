Rails.application.routes.draw do


  get 'pdf/:id' => 'pdf_view#show', as: 'pdf_view'

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
    delete 'creations/:id/comment/:cid' => 'creation#uncomment'
    #用户中心
    get 'usercenter' => 'usercenter#index'
    post 'usercenter/read_msg/:id' => 'usercenter#set_read_msg'  # 设置信息已读
    get 'usercenter/messages' => 'usercenter#messages', as:'usercenter_messages'
    get 'usercenter/messages/:id' => 'usercenter#show_msg'
    get 'usercenter/profile'
    post 'usercenter/profile' => 'usercenter#profile_handler'
    get 'usercenter/voted'
    get 'usercenter/commented'
    get 'usercenter/creations'
    get 'usercenter/creations/new' => 'usercenter#create_creation'

    get 'usercenter/creations/:id' => 'usercenter#creation_detail', as: 'creation_detail'
    get 'usercenter/creations/:id/edit' => 'usercenter#edit_creation', as: 'edit_creation'
    patch 'usercenter/creations/:id' => 'usercenter#update_creation'
    delete 'usercenter/creations/:id' => 'usercenter#delete_creation'
    patch 'usercenter/creations/:id/publish' => 'usercenter#publish_creation'
    delete 'usercenter/creations/:id/publish' => 'usercenter#unpublish_creation'

    #用户注册
    get 'user/reg'
    post 'user/reg' => 'user#create'
    post 'user/reg/validate' =>'user#validate'
    # 密码重设
    get 'user/reset'
    post 'user/reset' => 'user#reset_handler'

    post 'user/:id/email_verify' => 'user#send_email_verify', as: 'user_email_verify'
    get 'user/:id/email_verify/:code' => 'user#check_email_verify', as: 'user_check_email'

    #登陆控制
    get 'user/login'
    post 'user/login' => 'user#do_login'
    delete 'user/logout' => 'user#logout'

    get 'user/detail/:name' => 'user#show', as: 'user_detail'
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

    # 评论管理
    get 'comments/viewed' => 'comment#viewed'
    get 'comments/hidden' => 'comment#hidden'
    get 'comments' => 'comment#index'
    get 'comment/:id' => 'comment#show', as: 'comment'
    delete 'comment/:id' => 'comment#destroy'
    put 'comment/hide/:id' => 'comment#hide', as: 'hide_comment'
    put 'comment/view/:id' => 'comment#view', as: 'view_comment'

    # 设置
    get 'cfgs' => 'cfg#index'
    get 'cfg/exp_video' => 'cfg#exp_video'
    get 'cfg/intro' => 'cfg#intro'
    post 'cfg/add_intro' => 'cfg#add_intro', as: 'add_intro'
    delete 'cfg/intro/:id' => 'cfg#delete_intro', as: 'delete_intro'
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
