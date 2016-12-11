class UpdateAgeGroupsFields < ActiveRecord::Migration
  def change
    rename_column :characters_groups, :age_group, :age_from
    add_column :characters_groups, :age_to, :integer

    rename_column :characters, :age_group, :age_from
    add_column :characters, :age_to, :integer
  end
end
