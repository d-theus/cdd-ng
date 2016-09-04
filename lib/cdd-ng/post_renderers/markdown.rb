require 'rouge/plugins/redcarpet'

module PostRenderers
  class Markdown < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants
    include Rouge::Plugins::Redcarpet

    # Assumes link is never starts with a word character.
    # I.e. it's either an absolute link or a slug.
    def image(link, title, alt_text)
      src = if link[%r{^(http[s]?|/)}]
              link
            else
              PostPicture.friendly.find_by(slug: link).try(:image).try(:small) || ''
            end
      %(<figure class="post-figure"><a href='#{src}'><img src='#{src}' alt='#{alt_text}' /></a><figcaption>#{title}</figcaption></figure>)
    end

    def rouge_formatter(lexer)
      Rouge::Formatters::HTML.new(
        css_class: "highlight #{lexer.tag}",
        inline_theme: 'base16'
      )
    end
  end
end
