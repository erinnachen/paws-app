FactoryGirl.define do
  factory :dog_image do
    user nil
  end

  factory :user do
    uid "MyString"
    name "MyString"
    email "MyString"
    oauth_token "MyString"
  end
end
