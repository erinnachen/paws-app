class RenameUploadsToDogImages < ActiveRecord::Migration
  def change
    rename_table :uploads, :dog_images
  end
end
