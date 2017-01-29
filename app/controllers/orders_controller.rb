class OrdersController < ApplicationController

  def new
    @partner = Customer.first
    # @performances = Performance.all
    # @characters_with_groups = Character.where.not(characters_group_id: nil).group_by(&:characters_group_id)
    # @characters = Character.where(characters_group_id: nil)

    @objects = Performance.all.map{|p| [p.name, "performances_#{p.id}"]} +
      CharactersGroup.all.map{|cg| [cg.name, "characters_groups_#{cg.id}"]}
  end

end