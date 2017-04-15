class Api::StagesController < ApplicationController

  def index
    @stages = Stage.all.order('created_at DESC')
  end

  def show
    @stage = Stage.find(params[:id])
  end

end