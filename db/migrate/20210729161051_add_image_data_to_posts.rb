class AddImageDataToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :image_data, :jsonb
  end
end
