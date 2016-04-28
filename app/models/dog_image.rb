class DogImage < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  has_many :dog_breeds
  has_many :breeds, through: :dog_breeds


  has_attached_file :image, path: "dog_images/#{ENV["AWS_PATH"]}image-:id.:extension"
  validates :image, attachment_presence: true
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 3.megabytes
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :result, inclusion: { in: [nil, "correct", "wrong"] }
end
