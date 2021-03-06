ActiveAdmin.register Actor do

  permit_params :name, :contacts, :age, :telegram_key, :phone, :social,
                avatar_attributes: [:id, :file],
                actors_characters_attributes: [:id, :character_id, :actor_id, :_destroy]

  filter :name
  filter :characters,
         as: :select,
         collection: ->{Character.all.map{|ch| [ch.name, ch.id]}},
         label: 'Персонажи актера'
  filter :contacts
  filter :phone
  filter :age, as: :numeric
  filter :updated_at

  index do
    column :id
    column :name
    column :phone
    column :social
    column 'Аватар' do |record|
      if record.avatar
        image_tag(record.avatar.url(:middle_thumb))
      end
    end
    column :contacts
    column :characters do |record|
      record.characters.map(&:name).join(',')
    end
    column :age
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :phone
      f.input :name
      f.input :social
      f.input :contacts, input_html: { rows: 10, style: 'width:50%'}
      f.input :avatar, as: :file, hint: image_tag(f.object.avatar.url(:thumb))
      f.input :characters, as: :check_boxes, collection: Character.all, label: 'Персонажи'
      f.input :age
      f.input :telegram_key
    end
    f.actions
  end

  controller do

    def create
      characters = Character.where(id: actor_params.delete(:character_ids))
      @actor = Actor.new(actor_params)
      @actor.characters = characters
      if @actor.save
        redirect_to admin_actor_path(@actor)
      else
        render 'new'
      end
    end

    def update
      @actor = Actor.find(params[:id])
      characters = Character.where(id: actor_params.delete(:character_ids))
      @actor.update_attributes(actor_params)
      @actor.characters = characters
      if @actor.save
        redirect_to admin_actor_path(@actor)
      else
        render 'new'
      end
    end

    def actor_params
      params.require(:actor).permit(:name, :contacts, :age, :telegram_key, :phone, :social, :avatar,
                                    character_ids: [])

    end

  end

  show do |record|
    attributes_table do
      row :name
      row :age
      row :phone
      row :social
      row :contacts
      row :avatar do |record|
        if record.avatar
          image_tag record.avatar.url(:thumb)
        end
      end
      row t('admin.characters_list') do |record|
        record.characters.map do |character|
          link_to(character.name, admin_character_path(character))
        end.join('<br>').html_safe
      end
      row :telegram_key
      row :updated_at
    end

    render partial: 'admin/common/events_table', locals: {events: record.invitation_events}
  end

end