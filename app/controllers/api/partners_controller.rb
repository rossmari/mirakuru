class Api::PartnersController < ApplicationController

  def index
    @partners = Partner.all
  end

  def show
    @partner = Partner.find(params[:id])
  end

end