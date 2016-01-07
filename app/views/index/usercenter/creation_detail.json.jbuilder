json.extract! @creation, :id, :name, :desc, :summary, :version, :vote_count, :comment_count, :view_count, :created_at, :updated_at
json.status @creation.status_cn
json.thumb do
  json.large @creation.thumb.url
  json.small @creation.thumb.url(:thumb)
end
if @creation.doc.url
  json.doc do
    json.time File.mtime('./public' + @creation.doc.url.to_s)
    json.size @creation.doc.size
    json.url @creation.doc.url
  end
else
  json.doc ""
end

if @creation.ppt.url
  json.ppt do
    json.time File.mtime('./public' + @creation.ppt.url.to_s)
    json.size @creation.ppt.size
    json.url @creation.ppt.url
  end
else
  json.ppt ""
end
json.authors @creation.creation_authors