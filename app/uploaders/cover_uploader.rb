class CoverUploader < CarrierWave::Uploader::Base
  DEFAULT_IMG_FILE_NAME = 'width_500_default.png'.freeze
  MAIN_COVER_SIZE = 554
  SMALL_COVER_SIZE = 165

  include CarrierWave::MiniMagick

  Rails.env.production? ? (storage :aws) : (storage :file)

  def download_url(filename)
    url(response_content_disposition: %Q{attachment; filename="#{filename}"})
  end

  def default_url
    return ActionController::Base.helpers.asset_path([version_name, "default.png"].compact.join('_')) if version_name

    DEFAULT_IMG_FILE_NAME
  end

  version :width_500 do
    process resize_to_fit: [MAIN_COVER_SIZE, nil]
  end

  version :width_150 do
    process resize_to_fit: [SMALL_COVER_SIZE, nil]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
