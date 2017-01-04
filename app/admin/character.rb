ActiveAdmin.register Character do

  permit_params :name, :duration, :characters_group_id, :avatar, :age_from, :age_to,
                photo_attributes: [:id, :file, :_destroy], avatar_attributes: [:id, :file]

  config.per_page = 15

  filter :name
  filter :duration
  filter :age_from
  filter :age_to
  filter :updated_at

  index do
    column :id
    column :name
    column 'Аватар' do |record|
      if record.avatar
        image_tag(record.avatar.file.url(:small_thumb))
      end
    end
    column 'Возрастная группа' do |record|
      "От #{record.age_from} до #{record.age_to} лет"
    end
    column :duration
    column :characters_group
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :duration, include_blank: false
      f.input :characters_group, as: :select, include_blank: true, prompt: t('admin.no_group')
      f.inputs 'Возрастная группа' do
        f.input :age_from
        f.input :age_to
      end
      f.has_many :avatar, new_record: false, allow_destroy: false, heading: false do |b|
        b.input :file, label: 'Фотография главная', hint: photo_hint(b.object)
      end
      f.has_many :photo, new_record: true, allow_destroy: true, heading: 'Дополнительные фотографии' do |c|
        c.input :file, hint: photo_hint(c.object)
      end
    end
    f.actions
  end

  controller do
    def new
      @character = Character.new
      @character.build_avatar
    end

    def edit
      @character = Character.find(params[:id])
      unless @character.avatar
        @character.build_avatar
      end
    end

  end

  show do
    attributes_table do
      row :name
      row :duration
      row :age_from
      row :age_to
      row :character_group do |record|
        if record.characters_group
          record.characters_group.name
        else
          t('admin.no_group')
        end
      end
      row :avatar do |record|
        image_tag record.avatar.file.url(:thumb)
      end
      row 'Дополнительные фотографии' do |record|
        record.photo.map do |photo|
          content_tag(:div, image_tag(photo.file.url(:thumb)), class: 'additional_photo')
        end.join('').html_safe
      end
    end
  end

end