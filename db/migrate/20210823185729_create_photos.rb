class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.references :album, foreign_key: true
      t.string :titre
      t.text :image_data

      t.timestamps
    end
  end
end
