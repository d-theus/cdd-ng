# encoding: utf-8

class PostPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [64,64]
  end

  version :small do
    process resize_to_fit: [720,720]
  end

  version :large do
    process resize_to_fit: [1280, 1280]
  end
end
