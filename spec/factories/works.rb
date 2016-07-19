FactoryGirl.define do
  factory :work do
    title "MyString"
    description "MyString"
    website_link "MyString"
    github_link "MyString"

    image { Struct.new(:url, :thumb_url, :small_url, :large_url) }

    trait :with_image do
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'vendor', 'assets', 'images', 'placeholder.png'))}
    end
  end
end
