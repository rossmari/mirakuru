ActiveAdmin.register CharactersGroup do

  permit_params :name, :description, :age_from, :age_to,
                avatar_attributes: [:file, :id, :_delete]

  filter :characters,
         as: :select,
         collection: ->{Character.all.map{|ch| [ch.name, ch.id]}},
         label: 'Персонажи'
  filter :name
  filter :age_from
  filter :age_to

  index do
    column :id
    column :name
    column 'Возрастная группа' do |record|
      "От #{record.age_from} до #{record.age_to} лет"
    end
    column :avatar do |record|
      if record.avatar
        image_tag(record.avatar.file.url(:middle_thumb))
      else
        'Нет аватарки группы'
      end
    end
    column 'Персонажи' do |record|
      record.characters.map do |character|
        link_to(character.name, admin_character_path(character))
      end.join('<br>').html_safe
    end
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, input_html: { rows: 10, style: 'width:50%'}
      f.inputs 'Возрастная группа' do
        f.input :age_from
        f.input :age_to
      end
      f.has_many :avatar, new_record: false, allow_destroy: false, heading: false do |b|
        b.input :file, label: 'Аватарка группы', hint: photo_hint(b.object)
      end
    end
    f.actions
  end

  controller do
    def new
      @characters_group = CharactersGroup.new
      @characters_group.build_avatar
    end

    def edit
      @characters_group = CharactersGroup.find(params[:id])
      unless @characters_group.avatar
        @characters_group.build_avatar
      end
    end

  end

  show do
    attributes_table do
      row :name
      row :description
      row :age_from
      row :age_to
      row :avatar do |record|
        if record.avatar
          image_tag record.avatar.file.url(:thumb)
        end
      end
    end
  end


end
