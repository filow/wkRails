class Manage::MessagesController < ManageController
  def create
    message_content = manage_message_params
    @messages = {done: [], fail: []}
    userid = params[:user_id]
    userid.each do |id|
      m = Manage::Message.new(message_content)
      m.user_id = id
      if m.save
        @messages[:done].push(m)
      else
        @messages[:fail].push(m)
      end
    end
    render :result
    # if @message.save
    #   redirect_to manage_users_path, notice: "新的站内信 #{@message.title} 创建成功！"
    # else
    #   render :new
    # end
  end
  # GET /manage/users/1/message
  def new
    ids = params[:id].split(',')

    @target_users = Manage::User.find(ids)
    # @from =
    @message = Manage::Message.new(from: session['admin_realname'])
    # @recent_froms = Manage::Message
  end

  private

  def manage_message_params
    params.require(:message).permit(:from,:title,:content)
  end
end
