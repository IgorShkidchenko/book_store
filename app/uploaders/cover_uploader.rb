class CoverUploader < CarrierWave::Uploader::Base
   include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    return ActionController::Base.helpers.asset_path([version_name, "default.png"].compact.join('_')) if version_name

    'w500_default.png'
  end

  version :w500 do
    process resize_to_fit: [554, nil]
  end

  version :w150 do
    process resize_to_fit: [165, nil]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
