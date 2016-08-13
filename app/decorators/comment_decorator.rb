class CommentDecorator < Decorator::Base
  def avatar
    return if @object.avatar_url.blank?
    %(<img class="circle" src="#{@object.avatar_url}" alt="#{@object.name}"></img>)
  end

  def avatar_placeholder
    %(<i class="material-icons">face</i>)
  end

  def profile_link
    return if @object.profile_link.blank?
    @context.link_to @object.profile_link do
      name
    end
  end

  def name
    "<strong>#{@object.name}</strong>"
  end

  def created_at
    @object.created_at.strftime('%-d %b, %Y')
  end
end
