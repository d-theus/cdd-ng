FactoryGirl.define do
  factory :tag, class: ActsAsTaggableOn::Tag do
    sequence(:name) do |i|
      "tag#{i}"
    end
  end
end
