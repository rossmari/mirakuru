ActiveAdmin.register PricePosition do

  index do
    column :id
    column :minutes
    column :animators_count

    column 'Цена за 1 аниматора' do |record|
      "#{record.partner_price} / #{record.open_price} / #{record.exclusive_price}"
    end

    column 'ЗП аниматора' do |record|
      "#{record.partner_salary} / #{record.open_salary} / #{record.exclusive_salary}"
    end
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :minutes
      f.input :animators_count
      f.input :partner_price
      f.input :open_price
      f.input :exclusive_price
      f.input :partner_salary
      f.input :open_salary
      f.input :exclusive_salary
    end
    f.actions
  end

  collection_action :fill, method: :get do
    @price_positions = PricePosition.all
    @page_title = 'Прайс лист аниматоров'
    render 'fill', locals: {pp: @price_positions}
  end

  action_item :view, only: :index do
    link_to 'Изменить цены', fill_admin_price_positions_path
  end

  controller do
    def create
      (1..5).each do |animators_count|
        position = PricePosition.new(position_params)
        position.animators_count = animators_count
        position.save
      end
      redirect_to admin_price_positions_path
    end

    def position_params
      params.require(:price_position).permit(:minutes)
    end
  end

end