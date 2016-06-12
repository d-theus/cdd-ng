FactoryGirl.define do
  factory :post_picture do
    caption "MyString"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'vendor', 'assets', 'images', 'placeholder.png'))}
  end
end
