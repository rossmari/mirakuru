class OrderObjects::Presenter

  class << self

    def all_order_objects
      objects_list(Character.all, Performance.all)
    end

    def objects_list(characters, performances)
      objects = characters + performances
      objects.map{|object| object_description(object)}
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
      if group_exist?(character.characters_group_id)
        get_group_description(character.characters_group_id)
      else
        'Без группы'
      end
      "#{group_name} / #{character.name}"
    end

    def group_exist?(group_id)
      OrderObjects::GlobalStore.groups_keys.include?(group_id)
    end

    def get_group_description(group_id)
      OrderObjects::GlobalStore.groups[group_id]
    end

  end
end