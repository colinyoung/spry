module Spry
  class Entity < NSManagedObject
    def self.inherited(subclass)
      subclass.instance_variable_set(:@attributes, [])
    end

    def self.entity
      @entity ||= begin
        entity = NSEntityDescription.alloc.init
        entity.name = self.name
        entity.managedObjectClassName = entity.name
        entity.properties = @attributes

        entity
      end
    end

    def self.field(name, options={})
      attributeDescription = NSAttributeDescription.alloc.init
      attributeDescription.name = name.to_s
      attributeDescription.optional = false

      if options[:type] == String
        attributeDescription.attributeType = NSStringAttributeType
      elsif options[:type] == Time
        attributeDescription.attributeType = NSDateAttributeType
      else
        raise "Unknown field type: #{options[:type]}"
      end

      @attributes << attributeDescription
    end
  end
end
