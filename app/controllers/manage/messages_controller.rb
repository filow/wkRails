class Manage::MessagesController < ManageController
  def create
    @message = Manage::Message.new(manage_message_params)

    if @message.save
      redirect_to manage_users_path, notice: "新的站内信 #{@message.title} 创建成功！"
    else
      render :new
    end
  end
  # GET /manage/users/1/message
  def new
    @target_users = [Manage::User.find(params[:id])].flatten
    # @from =
    @message = Manage::Message.new
    # @recent_froms = Manage::Message
  end

  private

  def manage_message_params
    params.require(:message).permit(:user_id,:from,:title,:content)
  end
end
