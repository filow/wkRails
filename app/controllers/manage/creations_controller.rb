class Manage::CreationsController < ManageController
  before_action :set_manage_creation, only: [:show, :edit, :update, :destroy]

  # GET /manage/creations
  # GET /manage/creations.json
  def index
    @manage_creations = Manage::Creation.all
  end

  # GET /manage/creations/1
  # GET /manage/creations/1.json
  def show
  end

  # GET /manage/creations/new
  def new
    @manage_creation = Manage::Creation.new
  end

  # GET /manage/creations/1/edit
  def edit
  end

  # POST /manage/creations
  # POST /manage/creations.json
  def create
    @manage_creation = Manage::Creation.new(manage_creation_params)

    respond_to do |format|
      if @manage_creation.save
        format.html { redirect_to @manage_creation, notice: 'Creation was successfully created.' }
        format.json { render :show, status: :created, location: @manage_creation }
      else
        format.html { render :new }
        format.json { render json: @manage_creation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/creations/1
  # PATCH/PUT /manage/creations/1.json
  def update
    respond_to do |format|
      if @manage_creation.update(manage_creation_params)
        format.html { redirect_to @manage_creation, notice: 'Creation was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_creation }
      else
        format.html { render :edit }
        format.json { render json: @manage_creation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/creations/1
  # DELETE /manage/creations/1.json
  def destroy
    @manage_creation.destroy
    respond_to do |format|
      format.html { redirect_to manage_creations_url, notice: 'Creation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_creation
      @manage_creation = Manage::Creation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_creation_params
      params.require(:manage_creation).permit(:name, :desc, :vote_count, :comment_count, :view_count, :popularity, :summary, :thumb, :status, :version)
    end
end
