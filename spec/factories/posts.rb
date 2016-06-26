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

    trait :with_tags do
      transient do
        tags_count 3
      end
      after(:build) do |user, evaluator|
        user.tags = build_list(:tag, evaluator.tags_count)
      end
      after(:stub) do |user, evaluator|
        user.tags = build_list(:tag, evaluator.tags_count)
      end
    end

    trait :with_picture do
      after(:create) do |post|
        pic = FactoryGirl.create(:post_picture, slug: 'slug')
        post.text << <<-EOF
![#{pic.caption}](#{pic.slug} "#{pic.caption}")
        EOF
        post.save
      end

      after(:stub) do |post|
        pic = FactoryGirl.build_stubbed(:post_picture, slug: 'slug')
        post.text << <<-EOF
![#{pic.caption}](#{pic.slug} "#{pic.caption}")
        EOF
        post.pictures = [pic]
      end
    end

    trait :with_pictures do
      after(:create) do |post|
        3.times do |i|
          pic = FactoryGirl.create(:post_picture, slug: "slug-#{i}")
          post.text << <<-EOF
![#{pic.caption}](#{pic.slug} "#{pic.caption}")
          EOF
        end
        post.save
      end

      after(:stub) do |post|
        post.pictures = Array.new(3) do |i|
          pic = FactoryGirl.build_stubbed(:post_picture, slug: "slug-#{i}")
          post.text << <<-EOF
![#{pic.caption}](#{pic.slug} "#{pic.caption}")
          EOF
          pic
        end
      end
    end
  end
end
