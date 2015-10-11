class Manage::UsersController < ManageController
  before_action :set_manage_user, only: [:show, :edit, :update, :destroy]

  # GET /manage/users
  # GET /manage/users.json
  def index
    sort_group = ["id","realname","popularity"];
    @sorted = {};
    sort_group.each do |x|
      @sorted[x.to_sym]=1
    end
    if !params[:sort_by].nil?

      @sorted[params[:sort_by].to_sym] = params[:sort_type]

      case(params[:sort_by])
      when "id"
        if params[:sort_type] == "1"
          @manage_users = Manage::User.order(id: :asc).page(params[:page])
        else
          @manage_users = Manage::User.order(id: :desc).page(params[:page])
        end
      when "realname"
        if params[:sort_type] == "1"
          @manage_users = Manage::User.order(realname: :asc).page(params[:page])
        else
          @manage_users = Manage::User.order(realname: :desc).page(params[:page])
        end
      when "popularity"
        if params[:sort_type] == "1"
          @manage_users = Manage::User.order(popularity: :asc).page(params[:page])
        else
          @manage_users = Manage::User.order(popularity: :desc).page(params[:page])
        end
      else
      end

    else
      @manage_users = Manage::User.all
    end

  end

  # GET /manage/users/1
  # GET /manage/users/1.json
  def show
  end

  # GET /manage/users/new
  def new
    @manage_user = Manage::User.new
  end

  # GET /manage/users/1/edit
  def edit
  end

  # POST /manage/users
  # POST /manage/users.json
  def create
    @manage_user = Manage::User.new(manage_user_params)

    respond_to do |format|
      if @manage_user.save
        format.html { redirect_to @manage_user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @manage_user }
      else
        format.html { render :new }
        format.json { render json: @manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/users/1
  # PATCH/PUT /manage/users/1.json
  def update
    respond_to do |format|
      if @manage_user.update(manage_user_params)
        format.html { redirect_to @manage_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_user }
      else
        format.html { render :edit }
        format.json { render json: @manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/users/1
  # DELETE /manage/users/1.json
  def destroy
    @manage_user.destroy
    respond_to do |format|
      format.html { redirect_to manage_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_user
      @manage_user = Manage::User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_user_params
      params.require(:manage_user).permit(:name, :realname, :password_digest, :sex, :idcard, :group, :department, :phone, :email, :is_forbidden, :is_email_verified, :opus_count, :msg_unread, :avatar, :popularity,:sort_by,:sort_type)
    end
end
