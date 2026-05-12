module ObjectHelpers
  refine Object do
    def blank?
      nil? || (is_a?(String) && empty?)
    end
  end
end
