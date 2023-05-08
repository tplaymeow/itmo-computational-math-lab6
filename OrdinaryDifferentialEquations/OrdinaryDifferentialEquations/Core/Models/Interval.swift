struct Interval {
  let from: Double
  let to: Double

  init(_ a: Double, _ b: Double) {
    self.from = min(a, b)
    self.to = max(a, b)
  }
}
