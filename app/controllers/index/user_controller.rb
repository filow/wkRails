class Index::UserController < IndexController
  def reg
  end

  def login
  end

  def show
  end

  def create
  end

  def edit
      user = Manage::User.find_by(email: params[:email])
    if user && !user.is_email_verified? && user.authenticated?(:activation, params[:id])
      user.activate
      redirect_to user
    else
      redirect_to root_url
    end
  end
end
