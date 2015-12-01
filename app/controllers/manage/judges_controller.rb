class Manage::JudgesController < ManageController
  def index
    @creations  = Manage::Creation.where(status: Manage::Creation.statuses[:published])
  end

  def show
    # 被评审的作品
    @manage_creation = Manage::Creation.find(params[:id])
    # 已有的评审结果
    @judges = @manage_creation.judges
    # 当前管理员的评审
    judge = @judges.where admin_id: params[:id]
    if judge.empty?
      @judge = Manage::Judge.new
    else
      @judge = judge[0]
    end
  end

  def create
    @judge = Manage::Judge.new(judge_params)
    @judge.admin_id = session[:admin_id]
    if @judge.save
      redirect_to :back, notice: '您已成功评审！'
    else
      redirect_to :back, alert: '评审失败，请重试！'
    end
  end

  def update

  end

  private
  def judge_params
    params.require(:manage_judge).permit(:rank, :comment, :creation_id)
  end
end
