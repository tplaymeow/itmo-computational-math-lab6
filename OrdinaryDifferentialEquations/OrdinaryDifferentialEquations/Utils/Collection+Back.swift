extension Collection {
  subscript(back i: Int) -> Element {
    self[self.index(self.endIndex, offsetBy: -i)]
  }
}
