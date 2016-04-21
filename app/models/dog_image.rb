class DogImage < ActiveRecord::Base
  belongs_to :user

  has_attached_file :image, path: "dog_images/image-:id.:extension"
  validates :image, attachment_presence: true
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 2.megabytes
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
