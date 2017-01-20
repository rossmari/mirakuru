class Api::ActorsController < ApplicationController

  def index
    @actors = Actor.all
    if params[:character_id].present?
      # @actors = @actors.where()
      @actors = @actors.joins(:characters).where('characters.id = ?', params[:character_id])
    end
    @invitations = @actors.map do |actor|
      actor_invitations = Invitation.accepted.where(actor_id: actor.id).where('start > ?', DateTime.now)
      [actor.id, actor_invitations.map{|i| {start: i.start, stop: i.stop}}]
    end.to_h
  end

end