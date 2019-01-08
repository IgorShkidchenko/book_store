class CoverUploader < CarrierWave::Uploader::Base
   include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    'default.jpg'
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :show_page_big do
    process resize_to_fit: [550, nil]
  end

  version :show_page_small do
    process resize_to_fit: [50, nil]
  end

  version :home_slider do
    process resize_to_fit: [250, nil]
  end

  version :catalog do
    process resize_to_fit: [150, nil]
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
