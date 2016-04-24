class AddResultToDogImages < ActiveRecord::Migration
  def change
    add_column :dog_images, :result, :string
  end
end
