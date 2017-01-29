class Api::CharactersGroupsController < ApplicationController

  def show
    @group = CharactersGroup.find(params[:id])
    render json: @group.characters.map{|c| {id: c.id, name: c.name}}
  end

end