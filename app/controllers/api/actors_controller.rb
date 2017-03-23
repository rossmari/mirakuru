class Api::ActorsController < ApplicationController
  include ParamsParsing

  def index

  end

  def time_table
    @actor_manager = Order::ActorsManager.new(order)
    free_actors_count = Actor.all.select{|actor| @actor_manager.actor_free?(actor, position) }.count
    actors_template = render_to_string(partial: 'admin/orders/position_actors', locals: { position: position, index: params[:index] })
    render json: { free_actors: free_actors_count, template: actors_template }
  end

  def occupation_time
    date = Date.parse(params[:date])
    object = extract_object_from_description(params[:object_name])
    characters =
      if object.is_a?(Character)
        [object]
      elsif object.is_a?(Performance)
        object.characters
      end
    statuses = %w(accepted assigned)
    positions = Position.where(character_id: characters.map(&:id)).where('date(start) = ?', date)
    positions = positions.select{|p| (p.invitations.map(&:status) & statuses).any? }

    result = {}
    positions.map do |position|
      start = position.start - 1.hour
      stop = position.stop + 1.hour
      res = []
      (start.to_i..stop.to_i).step(1.hour) do |date|
        res << Time.at(date).in_time_zone(Time.zone).hour
      end
      result[position.character_id] = res
    end
    if result.blank?
      characters.each do |character|
        result[character.id] = {}
      end
    end
    render json: { occupation_time: result }
  end

  private

  def position_params
    params.require(:position).permit(:character_id, :start, :stop, :order_id, :id)
  end

  def order
    params[:order_id].present? ? Order.find(params[:order_id]) : nil
  end

  def position
    if position_params[:id].present?
      position = Position.find(position_params[:id])
      position.assign_attributes(position_params)
      position
    else
      Position.new(position_params)
    end
  end

end