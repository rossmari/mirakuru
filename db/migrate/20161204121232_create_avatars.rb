class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :file
      t.string :cover_type, :string
      t.integer :cover_id, :integer
      t.timestamps null: false
    end
  end
end
