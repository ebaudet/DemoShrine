class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.text :cover_photo_data

      t.timestamps
    end
  end
end
