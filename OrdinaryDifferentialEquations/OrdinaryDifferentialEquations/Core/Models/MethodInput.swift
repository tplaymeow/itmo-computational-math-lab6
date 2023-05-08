struct MethodInput {
  let equation: Function2
  let interval: Interval
  let initialY: Double
  let stepLength: Double
}

struct MilneMethodInput {
  let equation: Function2
  let interval: Interval
  let initialY: Double
  let stepLength: Double
  let tolerance: Double
}

extension MethodInput {
  func increasedAccuracy() -> Self {
    .init(
      equation: self.equation,
      interval: self.interval,
      initialY: self.initialY,
      stepLength: self.stepLength / 2.0
    )
  }
}

extension MilneMethodInput {
  func with(pointsCount: Int) -> MethodInput {
    .init(
      equation: self.equation,
      interval: .init(
        self.interval.from,
        self.interval.from +
        self.stepLength *
        Double(pointsCount - 1)
      ),
      initialY: self.initialY,
      stepLength: self.stepLength
    )
  }
}
