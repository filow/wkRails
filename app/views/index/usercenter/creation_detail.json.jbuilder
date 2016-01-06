json.extract! @creation, :id, :name, :desc, :summary, :status, :version, :vote_count, :comment_count, :view_count, :created_at, :updated_at
json.thumb do
  json.large @creation.thumb.url
  json.small @creation.thumb.url(:thumb)
end
if @creation.doc.url
  json.doc @creation.doc
else
  json.doc ""
end

if @creation.ppt.url
  json.ppt @creation.ppt
else
  json.ppt ""
end
json.authors @creation.creation_authors