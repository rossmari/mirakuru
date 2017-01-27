class OrdersController < ApplicationController

  def new
    @partner = Customer.first
    @performances = Performance.all
    @characters = Character.all
  end

end