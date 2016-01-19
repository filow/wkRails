# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
vendor_allowd_files = ['jquery.uploadifive.js', 'animate.css', 'inspinia/style.css']
Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js)\z/
    # if path.split('/')[-1] =~ /^_/
    #     false
    # else
    #     true
    # end
    full_path = Rails.application.assets.resolve(path)
    app_assets_path = Rails.root.join('app', 'assets').to_s
    lib_assets_path = Rails.root.join('lib', 'assets').to_s
    vendor_assets_path = Rails.root.join('vendor', 'assets').to_s
    if full_path.starts_with?(app_assets_path) || full_path.starts_with?(lib_assets_path)
      # puts "including asset: " + full_path
      true
    else
      if full_path.starts_with?(vendor_assets_path)
        vendor_allowd_files.include?(path)
      else
        false
      end
    end
  else
    # puts "excluding asset: " + path
    false
  end
end
