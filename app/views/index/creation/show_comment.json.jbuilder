json.page do
  json.current params[:page] || 1
  json.total @comments.total_pages
end
json.comments do
  json.array! @comments do |comment|
    json.id comment.id
    json.content comment.message.html_safe
    json.created_at comment.created_at
    json.author do
      json.is_current_user comment.user.id == session[:user_id]
      json.avatar comment.user.avatar.thumb.url
      json.username comment.user.realname
      json.homepage user_detail_path(comment.user)
    end
  end
end
