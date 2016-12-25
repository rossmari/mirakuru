module ParamsParsing

  def extract_object(params)
    object_description = params[:id]
    matches = object_description.match(/(\S+)_(\d+)/)
    object_class = matches[1]
    object_id = matches[2]
    object_class.capitalize.constantize.find(object_id)
  end

end