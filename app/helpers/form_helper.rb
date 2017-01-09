# encoding: utf-8
module FormHelper
  def link_to_add_fields(name, f, association, options = {})
    partial = association.to_s.singularize + "_fields"
    new_object = f.object.send(association).klass.new

    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(partial, f: builder)
    end

    link_to name, '#', class: "add-fields #{options[:class]}", data: {id: id, fields: fields.gsub("\n", "")}
  end
end