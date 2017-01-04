class Api::CharactersController < ApplicationController

  def available
    @characters = Character.where.not(id: params[:selected_characters])
  end

end