# encoding: utf-8

class PostPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Backgrounder::Delay

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [64,64]
  end

  version :small do
    process resize_to_fill: [780,640]
  end

  version :large do
    process resize_to_fill: [1280, 1280]
  end
end
