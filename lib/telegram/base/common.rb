module Telegram::Base::Common

  def position_short_name(position)
    order = position.order
    "#{date(position)}, #{start(position)} - #{stop(position)}, #{position.character.name}, #{order.stage.street}"
  end

  def date(position)
    position.start.strftime('%Y.%m.%d')
  end

  def start(position)
    position.start.strftime('%H:%M')
  end

  def stop(position)
    position.stop.strftime('%H:%M')
  end

end