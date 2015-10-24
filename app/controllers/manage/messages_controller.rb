class Manage::MessagesController < ManageController
  def create
    message_content = manage_message_params
    @messages = {done: [], fail: []}
    userid = params[:user_id]
    userid.each do |id|
      user = Manage::User.find(id)
      m = user.send_message(message_content)
      if m.errors.count == 0 
        @messages[:done].push(m)
      else
        @messages[:fail].push(m)
      end
    end
    render :result
  end
  # GET /manage/users/1/message
  def new
    ids = params[:id].split(',')

    @target_users = Manage::User.find(ids)
    @message = Manage::Message.new(from: session['admin_realname'])
  end

  private

  def manage_message_params
    params.require(:message).permit(:from,:title,:content)
  end
end
