class Hash
  def stringify_keys
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end if !{}.respond_to?(:stringify_keys)
end
