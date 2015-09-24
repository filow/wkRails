class Manage::AdminsController < ManageController
  before_action :set_manage_admin, only: [:show, :edit, :update, :destroy]

  # GET /manage/admins
  # GET /manage/admins.json
  def index
    @manage_admins = Manage::Admin.all
  end

  # GET /manage/admins/1
  # GET /manage/admins/1.json
  def show
  end

  # GET /manage/admins/new
  def new
    @manage_admin = Manage::Admin.new
  end

  # GET /manage/admins/1/edit
  def edit
  end

  # POST /manage/admins
  # POST /manage/admins.json
  def create
    @manage_admin = Manage::Admin.new(manage_admin_params)

    respond_to do |format|
      if @manage_admin.save
        format.html { redirect_to @manage_admin, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @manage_admin }
      else
        format.html { render :new }
        format.json { render json: @manage_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/admins/1
  # PATCH/PUT /manage/admins/1.json
  def update
    respond_to do |format|
      if @manage_admin.update(manage_admin_params)
        format.html { redirect_to @manage_admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_admin }
      else
        format.html { render :edit }
        format.json { render json: @manage_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/admins/1
  # DELETE /manage/admins/1.json
  def destroy
    @manage_admin.destroy
    respond_to do |format|
      format.html { redirect_to manage_admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_admin
      @manage_admin = Manage::Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_admin_params
      params.require(:manage_admin).permit(:uid, :password, :realname, :is_forbidden)
    end
end
