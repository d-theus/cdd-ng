module PicturesHelper
  def post_picture(slug)
    pic = PostPicture.friendly.find(slug)
    capture_haml do
      options = {
        src: pic.image.small,
        class: 'img-responsive'
      }
      options.merge!({ title: pic.caption, alt: pic.caption }) unless pic.caption.blank?
      haml_tag :figure do
        haml_tag :img, options
        unless pic.caption.blank?
          haml_tag :figcaption, pic.caption
        end
      end
    end
  end
end
