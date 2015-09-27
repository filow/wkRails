json.array!(@manage_posts) do |manage_post|
  json.extract! manage_post, :id, :title, :content, :content_notag, :valid_from, :is_top, :is_hide
  json.url manage_post_url(manage_post, format: :json)
end
