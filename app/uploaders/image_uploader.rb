# app/uploaders/image_uploader.rb
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  # 画像のバリデーションやバージョンを設定
  version :thumbnail do
    process resize_to_fit: [50, 50]
  end
end
