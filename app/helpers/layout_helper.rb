module LayoutHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def is_active?(link_path, return_class = "active")
    current_page?(link_path) ? return_class : nil
  end

end