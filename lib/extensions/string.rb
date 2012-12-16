class String
  def snippet
    self.length < 100 ? self : self[0..97] + "..."
  end
end
