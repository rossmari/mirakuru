ActiveAdmin.register Actor do

  permit_params :name, :contacts, :age, :telegram_key, :phone,
                avatar_attributes: [:id, :file],
                actors_characters_attributes: [:id, :character_id, :actor_id, :_destroy]

  filter :name
  filter :characters,
         as: :select,
         collection: Character.all.map{|ch| [ch.name, ch.id]},
         label: 'Персонажи актера'
  filter :contacts
  filter :phone
  filter :age, as: :numeric
  filter :updated_at

  index do
    column :id
    column :name
    column 'Аватар' do |record|
      image_tag(record.avatar.file.url(:middle_thumb))
    end
    column :contacts
    column :age
    column :phone
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :contacts, :input_html => { :rows => 10, style: 'width:50%'}
      f.has_many :avatar, new_record: false, allow_destroy: false, heading: false do |b|
        b.input :file, label: 'Фотография актера-аниматора', hint: photo_hint(b.object)
      end
      f.has_many :actors_characters, new_record: true, allow_destroy: true do |c|
        c.input :character_id, as: :select, collection: Character.all.map{|ch| [ch.name, ch.id]}
      end
      f.input :age
      f.input :telegram_key
      f.input :phone
    end
    f.actions
  end

  controller do
    def new
      @actor = Actor.new
      @actor.build_avatar
    end

    def edit
      @actor = Actor.find(params[:id])
      unless @actor.avatar
        @actor.build_avatar
      end
    end

  end

  show do
    attributes_table do
      row :name
      row :age
      row :phone
      row :contacts
      row :avatar do |record|
        image_tag record.avatar.file.url(:middle_thumb)
      end
      row t('admin.characters_list') do |record|
        record.characters.map do |character|
          link_to(character.name, admin_character_path(character))
        end.join('<br>').html_safe
      end
      row :telegram_key
      row :updated_at
    end
  end

end