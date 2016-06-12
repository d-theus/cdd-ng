FactoryGirl.define do
  factory :post do
    title "MyString"
    slug nil
    text <<-EOF
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore.
<!--cut-->
Et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
no sea takimata sanctus est Lorem ipsum dolor sit amet.
EOF
  end

  trait :with_pictures do
    before(:create) do |post|
      5.times do
        pic = FactoryGirl.create(:post_picture)
        post.text << <<-EOF
[#{pic.caption}](#{pic.slug} "#{pic.caption}")
EOF
      end
    end
  end
end
