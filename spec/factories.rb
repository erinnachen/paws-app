FactoryGirl.define do
  factory :dog_breed do
    dog_image nil
    breed nil
  end

  factory :breed do
    name
  end

  factory :dog_image do
    user
    image { File.new("#{Rails.root}/spec/support/fixtures/aussie.jpg") }
  end

  factory :user do
    uid "1234"
    name "Doggie owner"
    email "doglover@example.com"
    oauth_token "gianthash2y3ahafnvaks"
  end

  sequence(:name) { |n| "Breed " + n.to_s }
end
