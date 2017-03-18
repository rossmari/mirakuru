class Api::CharactersController < ApplicationController

  def index
    @characters = Character.all
  end

  def available
    @characters = Character.where.not(id: params[:selected_characters])
  end

end