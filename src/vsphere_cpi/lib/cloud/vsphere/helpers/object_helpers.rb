module ObjectHelpers
  refine Object do
    def blank?
      self.nil? || (self.is_a?(String) && self.empty?)
    end
  end
end