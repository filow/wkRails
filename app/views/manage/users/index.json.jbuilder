json.array!(@manage_users) do |manage_user|
  json.extract! manage_user, :id, :name, :realname, :password_digest, :sex, :idcard, :group, :department, :phone, :email, :is_forbidden, :is_email_verified, :opus_count, :msg_unread, :avatar, :popularity
  json.url manage_user_url(manage_user, format: :json)
end
