class Api::PerformancesController < ApplicationController

  def show
    performance = Performance.find(params[:id])
    render json: performance.characters.map{|c| {id: c.id, name: c.name}}
  end

end