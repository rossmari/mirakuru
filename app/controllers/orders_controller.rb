class OrdersController < ApplicationController
  include ParamsParsing

  def new
    @partner = Customer.where(customer_type: Customer.customer_types[:partner], partner_link: params[:partner_key]).first

    @objects = Performance.all.map{|p| [p.name, "performances_#{p.id}"]} +
      CharactersGroup.all.map{|cg| [cg.name, "characters_groups_#{cg.id}"]}
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.new
    common_data = params[:order_info].first.last
    order.performance_date = common_data[:date]
    order.child_name = common_data[:childName]
    order.child_birthday = Date.today
    order.performance_time = DateTime.now
    order.guests_age_from = 20
    order.guests_age_to = 30
    order.additional_expense = 0
    # ??? to guests notice ?
    order.guests_notice = common_data[:orderNotice]
    order.child_notice = common_data[:childNotice]
    customer = Customer.find(params[:partner_id])
    order.customer_id = customer.id
    order.stage_id = customer.stages.first.id
    order.contact_id = customer.contacts.first.id
    order.performance_duration = common_data[:duration]
    # todo : change this
    order.order_source_id = OrderSource.find(2)
    params[:order_info].each do |_character_id, position_info|
      start = position_info[:maxTimeRange][:start].to_i
      stop = position_info[:maxTimeRange][:stop].to_i
      date = Date.parse(position_info[:date])
      character_id = position_info[:characterId]
      owner = extract_object_from_description(position_info[:ownerInfo])
      position_notice = "Продолжительность #{position_info[:duration]} минут"
      position_notice << $RS
      position_notice << "Желаемое время: #{position_info[:timeRanges].map{|index, range| "#{range[:start]}:00 - #{range[:stop]}:00" }.join(', ')}"
      order.positions << Position.new(
        start: create_date_time(date, start),
        stop: create_date_time(date, stop),
        character_id: character_id,
        order_notice: position_notice,
        owner_class: owner.class,
        fixed_start: true,
        fixed_stop: true,
        owner_id: owner.id
      )
    end
    if order.save
      render json: { status: 200 , order_id: order.id, valid: order.valid?, errors: order.errors.full_messages }
    else
      render json: { status: 422 }
    end
  end

  private

  # create DateTime from Date and Time with
  # correct Time Zone
  def create_date_time(d, hour)
    DateTime.new.in_time_zone(Time.zone).change(year: d.year, month: d.month, day: d.day, hour: hour, min: 0)
  end

end