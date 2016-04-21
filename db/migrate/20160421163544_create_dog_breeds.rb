class CreateDogBreeds < ActiveRecord::Migration
  def change
    create_table :dog_breeds do |t|
      t.references :dog_image, index: true, foreign_key: true
      t.references :breed, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
