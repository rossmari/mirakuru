class Api::ActorsController < ApplicationController

  def index

  end

  def time_table
    @actor_manager = Order::ActorsManager.new(order)
    free_actors_count = Actor.all.select{|actor| @actor_manager.actor_free?(actor, position) }.count
    actors_template = render_to_string(partial: 'admin/orders/position_actors', locals: { position: position, index: params[:index] })
    render json: { free_actors: free_actors_count, template: actors_template }
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