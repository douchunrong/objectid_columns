ObjectidColumns.available_objectid_columns_bson_classes.each do |klass|
  klass.class_eval do
    def to_binary
      [ to_s ].pack("H*")
    end

    def to_bson_id
      self
    end
  end
end

String.class_eval do
  BSON_ID_REGEX = /^[0-9a-f]{24}$/i

  def to_bson_id
    if self =~ BSON_ID_REGEX
      ObjectidColumns.construct_objectid(self)
    elsif length == 12 && encoding == Encoding::BINARY
      ObjectidColumns.construct_objectid(unpack("H*").first)
    else
      raise ArgumentError, "#{inspect} does not seem to be a valid BSON ID; it is in neither the valid hex (exactly 24 hex characters, any encoding) nor the valid binary (12 characters, binary/ASCII-8BIT encoding) form"
    end
  end
end
