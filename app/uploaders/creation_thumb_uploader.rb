# encoding: utf-8

class CreationThumbUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/creation_thumb/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  # 调整临时文件的存放路径，默认是在 public 下面
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  # Process files as they are uploaded:
  process :resize_to_fill => [640, 360]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [320, 180]
  end

  version :thumb_mini, :from_version => :thumb do
    process :resize_to_fill => [64, 36]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    Digest::SHA2.hexdigest(original_filename)[0..12]+Time.now.to_i.to_s+".#{original_filename.split('.')[-1]}" if original_filename
  end

end
