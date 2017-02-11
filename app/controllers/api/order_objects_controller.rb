class Api::OrderObjectsController < ApplicationController
  include ParamsParsing

  def index
    render json: { objects: [] }
  end

end