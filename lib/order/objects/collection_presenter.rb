class Order::Objects::CollectionPresenter

  class << self

    def present_collection(collection)
      collection.map do |object, characters_ids|
        object_id = Order::Objects::Presenter.object_value(object)
        name = Order::Objects::Presenter.object_name(object)
        [object_id,
         {
          id: object_id,
          instance_id: object.id,
          name: name,
          characters: characters_ids,
          available: true,
          class: object.class.name.downcase
         }
        ]
      end.to_h
    end

  end
end