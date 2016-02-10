module CategoriesHelper

  def nested_dropdown(items)
    result = []
    items.each do |item|
      if item.children.any?
        result <<  [('- ' * item.depth) + item.name, item.id, disabled: true]
      else
        result <<  [('- ' * item.depth) + item.name, item.id]
      end
      result += nested_dropdown(item.children) unless !item.children.any?
    end
    result
  end

end
