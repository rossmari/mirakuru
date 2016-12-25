class Api::StagesController < ApplicationController

  def index
    @stages = Stage.all
  end

  def show
    @stage = Stage.find(params[:id])
  end

end