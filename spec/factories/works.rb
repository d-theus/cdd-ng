FactoryGirl.define do
  factory :work do
    title "MyString"
    description "MyString"
    link "MyString"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'vendor', 'assets', 'images', 'placeholder.png'))}
  end
end
