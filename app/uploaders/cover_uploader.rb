class CoverUploader < CarrierWave::Uploader::Base
   include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    return ActionController::Base.helpers.asset_path([version_name, "default.jpg"].compact.join('_')) if version_name

    'w500_default.jpg'
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :w500 do
    process resize_to_fit: [554, nil]
  end

  version :w150 do
    process resize_to_fit: [165, nil]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
