# encoding: utf-8

class CreationPptUploader < CarrierWave::Uploader::Base

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/creation_ppt/#{model.id}"
  end

  def extension_whitelist
    %w(pdf)
  end
  def filename
    Digest::SHA2.hexdigest(original_filename)[0..12]+Time.now.to_i.to_s+".#{original_filename.split('.')[-1]}" if original_filename
  end
end
