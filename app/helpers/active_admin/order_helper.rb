module ActiveAdmin::OrderHelper

  def order_objects(characters, performances)
    objects = characters + performances
    objects.map{|object| object_description(object)}
  end

  def all_order_objects
    order_objects(Character.all, Performance.all)
  end

  def object_description(object)
    [object_name(object), object_value(object)]
  end

  def object_name(object)
    if object.is_a?(Character)
      character_full_name(object)
    elsif object.is_a?(Performance)
      performance_name(object)
    end
  end

  def object_value(object)
    if object.is_a?(Character)
      character_value(object)
    elsif object.is_a?(Performance)
      performance_value(object)
    end
  end

  def performance_value(performance)
    "performance_#{performance.id}"
  end

  def character_value(character)
    "character_#{character.id}"
  end

  def performance_name(performance)
    performance.name
  end

  def character_full_name(character)
    group_name =
      if character.characters_group
        character.characters_group.name
      else
        'Без группы'
      end
    "#{group_name} / #{character.name}"
  end

end

