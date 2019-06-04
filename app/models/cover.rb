class Cover < ApplicationRecord
  belongs_to :book
  mount_uploader :image, CoverUploader
end
