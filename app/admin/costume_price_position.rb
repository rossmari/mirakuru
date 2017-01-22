ActiveAdmin.register CostumePricePosition do

  permit_params :minutes, :costume_count, :partner, :open, :exclusive

  index do
    column :id
    column :minutes
    column :costume_count
    column :partner
    column :open
    column :exclusive
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :minutes
      f.input :costume_count
      f.input :partner
      f.input :open
      f.input :exclusive
    end
    f.actions
  end

  collection_action :fill, method: :get do
    @price_positions = CostumePricePosition.all
    @page_title = 'Прайс лист костюмов'
    render 'fill', locals: {pp: @price_positions}
  end

  action_item :view, only: :index do
    link_to 'Изменить цены', fill_admin_costume_price_positions_path
  end

  controller do
    def create
      (1..5).each do |animators_count|
        position = CostumePricePosition.new(position_params)
        position.costume_count = animators_count
        position.save
      end
      redirect_to admin_costume_price_positions_path
    end

    def position_params
      params.require(:costume_price_position).permit(:minutes, :costume_count, :partner, :open, :exclusive)
    end
  end

end