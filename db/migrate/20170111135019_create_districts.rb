class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.timestamps null: false
    end
    %w(Железнодорожный Кировский Ленинский Октябрьский Свердловский Советский Центральный).each do |district_name|
      District.create(name: district_name)
    end
  end
end
