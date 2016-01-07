json.extract! @creation, :id, :name, :desc, :summary, :status, :version, :vote_count, :comment_count, :view_count, :created_at, :updated_at
json.thumb do
  json.large @creation.thumb.url
  json.small @creation.thumb.url(:thumb)
end
if @creation.doc.url
  json.doc do
    json.time File.mtime('./public' + @creation.doc.url.to_s)
    json.size @creation.doc.size
  end
else
  json.doc ""
end

if @creation.ppt.url
  json.ppt do
    json.time File.mtime('./public' + @creation.ppt.url.to_s)
    json.size @creation.ppt.size
  end
else
  json.ppt ""
end
json.authors @creation.creation_authors