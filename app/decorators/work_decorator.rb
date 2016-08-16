class WorkDecorator < Decorator::Base
  def website_link
    return unless @object.website_link
    @context.link_to @object.website_link,
      rel: 'nofollow,noindex',
      title: "Visit website #{@object.website_link}",
      class: 'btn btn-fab btn-primary' do
      @context.raw '<i class="material-icons">link</i>'
    end
  end

  def github_link
    return unless @object.github_link
    @context.link_to @object.github_link,
      rel: 'nofollow,noindex',
      title: "Visit github project page: #{@object.github_link}",
      class: 'btn btn-fab btn-primary' do
        @context.raw '<i class="socicon socicon-github"></i>'
    end
  end

  def to_s
    @object.id.to_s
  end
end
