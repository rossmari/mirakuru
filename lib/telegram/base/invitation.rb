class Telegram::Base::Invitation < Telegram::Base::DataCallback
  include Telegram::Base::Common

  private

  def buttons
    raise NotImplementedError.new('You need to implement buttons block')
  end

  def header
    invitation_description
  end

  def invitation_description
    [
      position_short_name(position),
      child_information,
      position.order_notice,
      "Адрес: #{order.stage.address}.",
      team_description,
      "Заказ #{position.payed ? 'оплачен' : 'не оплачен'}.",
      "Стоймость заказа: #{position.price} рублей.",
      "ЗП: #{position.animator_money} рублей. (id: #{invitation.id})"
    ]
  end

  def child_information
    "Ребенка зовут #{order.child_name}, #{order.child_notice}"
  end

  def team_description
    positions = order.positions.where.not(id: position.id)
    if positions.any?
      "( + #{positions.count} персонажей: #{positions.map{|i| i.character.name}.join(', ')})"
    else
      ''
    end
  end

end