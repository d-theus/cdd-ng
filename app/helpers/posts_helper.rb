module PostsHelper
  DEFAULT_EXTENSIONS = {
    no_intra_emphasis: true,
    tables: true,
    fenced_code_blocks: true,
    disable_indented_code_blocks: true,
    superscript: true,
    footnotes: true
  }

  def post_thumb(post)
    capture_haml do
      haml_tag :img,
        class: 'img-responsive img-thumbnail',
        src: post.pictures.first.image.thumb
    end
  end

  def render_post(post)
    render_post_text(post.text)
  end

  def render_post_text(text)
    Redcarpet::Markdown.new(PostRenderers::Markdown, DEFAULT_EXTENSIONS).render(text)
  end
end
