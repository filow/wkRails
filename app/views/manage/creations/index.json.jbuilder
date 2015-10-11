json.array!(@manage_creations) do |manage_creation|
  json.extract! manage_creation, :id, :name, :desc, :vote_count, :comment_count, :view_count, :popularity, :summary, :thumb, :status, :version
  json.url manage_creation_url(manage_creation, format: :json)
end
