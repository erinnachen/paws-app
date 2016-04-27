class AddCatToDogImages < ActiveRecord::Migration
  def change
    add_column :dog_images, :cat, :boolean, default: false
  end
end
