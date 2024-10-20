# app/uploaders/image_uploader.rb
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :thumbnail do
    process resize_to_fit: [50, 50]
  end
end
