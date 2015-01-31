module PostsHelper
  def file_icon(file)
    if file.try(:image).try(:content_type).try(:include?, 'image')
      image_tag file.try(:image).try(:thumb).try(:url)
    else
      image_tag file.try(:image).try(:default_url)
    end
  end

  def current_controller
    controller.controller_name
  end
end
