class AddSocialLinkToActor < ActiveRecord::Migration
  def change
    add_column :actors, :social, :string
  end
end
