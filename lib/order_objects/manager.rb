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
    Character.all.each do |character|
      objects[character] = [character.id]
    end
    Performance.all.each do |performance|
      objects[performance] = []
      performance.characters.each do |character|
        objects[performance] << character.id
      end
    end
    objects
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