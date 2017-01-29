class Api::CharactersController < ApplicationController

  def index
    @characters = Character.all
  end

  def available
    @characters = Character.where.not(id: params[:selected_characters])
  end

  def partner_container
    characters = Character.where(id: params[:ids])
    data =
      characters.map do |character|
        [
          character.id,
          render_to_string('api/characters/partner_container', layout: false, locals: {character: character})
        ]
      end.to_h
    render json: {containers: data}
  end

end