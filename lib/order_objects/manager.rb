class OrderObjects::Manager

  attr_reader :selected_characters_ids, :all_objects

  def initialize(ids)
    @selected_characters_ids = ids.map(&:to_i)
    @all_objects = preload_objects
  end

  # grep all objects in format
  # { object id : [ characters ids ] }
  def preload_objects
    objects = {}
    Character.find_each do |character|
      objects[character] = [character.id]
    end
    Performance.find_each do |performance|
      objects[performance] = []
      performance.characters.each do |character|
        objects[performance] << character.id
      end
    end
    objects
  end

  def present_objects
    all_objects.map do |object, characters_ids|
      object_id = OrderObjects::Presenter.object_value(object)
      name = OrderObjects::Presenter.object_name(object)
      [object_id,
       {
        id: object_id,
        name: name,
        characters: characters_ids,
        available: true,
        class: object.class.name.downcase
       }
      ]
    end.to_h
  end

  def available_objects
    result = []
    all_objects.each do |object, character_ids|
      unless (character_ids & selected_characters_ids).any?
        result << object
      end
    end
    result
  end

end