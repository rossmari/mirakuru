class Api::OrderObjectsController < ApplicationController
  include ParamsParsing

  def index
    objects = OrderObjects::Manager.new([]).present_objects
    render json: { objects: objects }
  end

  def object_container

    @object = extract_object(params)

    @last_index = params[:object_index].to_i

    @characters =
      if @object.is_a?(Character)
        [@object]
      elsif @object.is_a?(Performance)
        @object.characters
      end

    @actors = {}
    @characters.each do |character|
      @actors[character.id] = character.actors.map{|actor| [name: actor.name, id: actor.id]}
    end

    # characters that was selected before
    selected_characters = params[:selected_characters] || []
    # characters that was selected right now - @characters
    selected_ids = (selected_characters.map(&:to_i) + @characters.map(&:id)).uniq
    available_objects = OrderObjects::Manager.new(selected_ids).available_objects

    container = render_to_string('api/order_objects/_order_object', layout: false)
    render json: { container: container, characters_left: available_objects.count}
  end

  def selector
    @objects = OrderObjects::Manager.new(params[:selected_characters]).available_objects
    container = render_to_string('api/order_objects/_order_object_selector', layout: false)
    render json: {container: container, characters_left: @objects.count}
  end

end