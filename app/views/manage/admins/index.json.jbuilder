json.array!(@manage_admins) do |manage_admin|
  json.extract! manage_admin, :id, :uid, :password, :realname, :is_forbidden
  json.url manage_admin_url(manage_admin, format: :json)
end
