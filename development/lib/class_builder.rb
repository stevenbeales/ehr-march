module ClassBuilder

  # by class_name return all fields {field: configs}, ..
  # ClassBuilder.fields(Provider)
  # => [...
  #     :last_name=>{:type=>String},
  #     :practice_role=>{:type=>Enum, :in=>[:Provider, :Hygientist ...], :default=>:Hygientist}
  # ...]
  def self.fields(class_name)
    class_name.fields.reject{ |field| field == :id || field == :created_at || field == :updated_at || field.to_s.include?('_id') }
  end

  # by class_name return array of belongs_to associations [[class_name, target_name], [..]]
  # ClassBuilder.associations(Provider)
  # => [["User", :user], ["Provider", :provider], ["Location", :practice_location]]
  def self.associations(class_name)
    class_name.association_metadata.map do |target_name, metadata|
      class_name = if metadata.class == NoBrainer::Document::Association::BelongsTo::Metadata
        metadata.options[:class_name].present? ? metadata.options[:class_name] : target_name.to_s.camelcase
      else
        nil
      end
      [class_name, target_name]
    end.delete_if{ |association| association[0].blank? }
  end
end