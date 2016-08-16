class PostDecorator < Decorator::Base

  DEFAULT_EXTENSIONS = {
    no_intra_emphasis: true,
    tables: true,
    fenced_code_blocks: true,
    disable_indented_code_blocks: true,
    superscript: true,
    footnotes: true
  }

  def render
    Redcarpet::Markdown.new(PostRenderers::Markdown, DEFAULT_EXTENSIONS).render(@object.text)
  end

  def thumb
    out = ''
    if @object.pictures.any?
      pic = @object.pictures.first
      out << image_tag(pic.image.thumb, title: @object.title, alt: @object.title, class: 'circle')
    else
      out << '<i class="material-icons">note</i>'
    end
  end

  def summary
    Redcarpet::Markdown.new(PostRenderers::Markdown, DEFAULT_EXTENSIONS).render(@object.summary)
  end

  def tags
    out = '<ul class="tags">'
    @object.tags.each_with_index do |tg, i|
      out << '<li>'
      out << link_to(tg, tagged_posts_path(tag: tg.name))
      out << '</li>'
      out << ', ' if i < @object.tags.size - 1
    end
    out << '</ul>'
    out
  end

  def to_s
    @object.slug
  end
end
