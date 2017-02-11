class Api::OrderSourcesController < ApplicationController

  def index
    @sources = OrderSource.all.order('id DESC')
  end

end