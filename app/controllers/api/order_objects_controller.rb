class Api::OrderObjectsController < ApplicationController
  include ParamsParsing

  def index
    render json: { objects: [] }
  end

  def show
    @description = params[:id]
    object = extract_object(params)

    @last_index = params[:object_index].to_i

    @characters =
      if object.is_a?(Character)
        [object]
      elsif object.is_a?(Performance)
        object.characters
      end

    container = render_to_string('orders/object', layout: false, locals: {object: object, characters: @characters})
    render json: { container: container }
  end

end