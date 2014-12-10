# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf xls doc docx xlsx csv)
  end

  def default_url
    "file.png"
  end

  version :thumb, if: :image? do
    process resize_to_fill: [50, 50]
  end

  protected

  def image?(new_file)
    new_file.content_type.include? 'image'
  end
end
