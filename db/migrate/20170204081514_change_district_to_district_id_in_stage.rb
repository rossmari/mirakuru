class ChangeDistrictToDistrictIdInStage < ActiveRecord::Migration
  def change
    rename_column :stages, :district, :district_id
  end
end
