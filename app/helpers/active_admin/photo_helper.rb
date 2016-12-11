module ActiveAdmin::PhotoHelper

  def photo_hint(object)
    if object.file.present?
      image_tag(object.file.url(:thumb))
    else
      content_tag(:span, t('admin.file_not_loaded'))
    end
  end

end