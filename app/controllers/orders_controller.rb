class OrdersController < ApplicationController

  def new
    @partner = Customer.where(customer_type: Customer.customer_types[:partner], partner_link: params[:partner_key]).first

    @objects = Performance.all.map{|p| [p.name, "performances_#{p.id}"]} +
      CharactersGroup.all.map{|cg| [cg.name, "characters_groups_#{cg.id}"]}
  end

end