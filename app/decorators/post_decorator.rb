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

  def share_with_facebook_button
    fail 'No app_id specified for facebook' unless app_id = Rails.application.secrets.facebook_app_id
    link_to 'Share with Facebook', 'https://facebook.com/dialog/share?' + { 'display' => 'page', 'href' => post_url(@object, host: 'cddevel.com'), 'redirect_url' => post_url(@object, host: 'cddevel.com'), 'app_id' => app_id }.to_query, rel: 'noopener', target: '_blank'
  end

  def share_with_twitter_button
    link_to 'Share with Twitter', 'https://twitter.com/intent/tweet?' + { 'text' => @object.title, 'url' => post_url(@object) }.to_query, rel: 'noopener', target: '_blank'
  end

  def share_with_vk_button
  end

  def meta_for_facebook
    out = ""
    out << tag(:meta, property: 'fb:app_id', content: Rails.application.secrets.facebook_app_id)
    out << tag(:meta, property: 'og:type',   content: 'article')
    out << tag(:meta, property: 'og:url',    content: post_url(@object))
    out << tag(:meta, property: 'og:title',  content: @object.title)
    out << tag(:meta, property: 'og:image',  content: "#{Rails.configuration.action_controller.asset_host}#{image_path("logo.svg")}")
    out << tag(:meta, property: 'og:description',  content: @object.summary)
    out
  end

  def meta_for_twitter
    out = ''
    out << tag(:meta, name: 'twitter:card',  content: 'summary')
    out << tag(:meta, name: 'twitter:site',  content: '@cddevel')
    out << tag(:meta, name: 'twitter:title',  content: @object.title)
    out << tag(:meta, name: 'twitter:description',  content: @object.summary)
    out << tag(:meta, name: 'twitter:image',  content: "#{Rails.configuration.action_controller.asset_host}#{image_path("logo.svg")}")
    out
  end

  def to_s
    @object.slug
  end
end
