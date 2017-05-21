class Order::Objects::GlobalStore

  class << self
    def update_characters_descriptions
      return unless can_cache?
      @@groups = CharactersGroup.pluck('id, name').to_h
      @@groups_keys = CharactersGroup.pluck('id')
    end

    def groups_keys
      return unless can_cache?
      # @@groups_keys
      CharactersGroup.pluck('id')
    end

    def groups
      return unless can_cache?
      # @@groups
      CharactersGroup.pluck('id, name').to_h
    end

    def can_cache?
      ActiveRecord::Base.connection.table_exists?('characters_groups')
    end
  end
end
