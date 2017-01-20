class Order::Objects::Aggregator

  class << self
    def aggregate
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
  end

end