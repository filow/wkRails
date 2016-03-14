# encoding: utf-8
class CreationVideoUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    "uploads/creation_video/#{model.id}"
  end

  def filename
    Digest::SHA2.hexdigest(original_filename)[0..12]+Time.now.to_i.to_s+".#{original_filename.split('.')[-1]}" if original_filename
  end
end
