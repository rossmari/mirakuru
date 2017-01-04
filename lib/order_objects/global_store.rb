class OrderObjects::GlobalStore

  class << self
    def update_characters_descriptions
      @@groups = CharactersGroup.pluck('id, name').to_h
      @@groups_keys = CharactersGroup.pluck('id')
    end

    def groups_keys
      @@groups_keys
    end

    def groups
      @@groups
    end

  end
end
