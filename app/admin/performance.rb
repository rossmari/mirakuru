ActiveAdmin.register Performance do

  permit_params :name, :description, photo_attributes: [:id, :file, :_destroy],
                avatar_attributes: [:id, :file],
                performances_characters_attributes: [:id, :character_id, :performances_id, :_destroy]

  filter :name
  filter :description

  index do
    column :id
    column :name
    column 'Аватар' do |record|
      image_tag(record.avatar.file.url(:small_thumb))
    end
    column :description
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, input_html: { rows: 10, style: 'width:50%'}
      f.has_many :avatar, new_record: false, allow_destroy: false, heading: false do |b|
        b.input :file, label: 'Главная Фотография', hint: photo_hint(b.object)
      end
      f.has_many :photo, new_record: true, allow_destroy: true, heading: 'Дополнительные фотографии' do |c|
        c.input :file, hint: photo_hint(c.object)
      end
      f.has_many :performances_characters, new_record: true, allow_destroy: true do |c|
        c.input :character_id, as: :select, collection: Character.all.map{|ch| [ch.name, ch.id]}
      end
    end
    f.actions
  end

  controller do
    def new
      @performance = Performance.new
      @performance.build_avatar
    end

    def edit
      @performance = Performance.find(params[:id])
      unless @performance.avatar
        @performance.build_avatar
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :avatar do |record|
        image_tag record.avatar.file.url(:thumb)
      end
      row 'Дополнительные фотографии' do |record|
        record.photo.map do |photo|
          content_tag(:div, image_tag(photo.file.url(:thumb)), class: 'additional_photo')
        end.join('').html_safe
      end
      row 'Персонажи' do |record|
        record.characters.map do |character|
          link_to(character.name, admin_character_path(character))
        end.join('<br>').html_safe
      end
    end
  end


end