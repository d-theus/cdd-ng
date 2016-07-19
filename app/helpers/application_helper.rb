module ApplicationHelper
  def admin?
    current_admin
  end

  def nav_link(title, href)
    active = current_page?(href)
    capture_haml do
      haml_tag :li, class: (active ? 'active' : nil) do
        haml_tag :a, href: href, title: title do
          haml_concat title
        end
      end
    end
  end

  # FIXME
  def about_path
    ''
  end
end
