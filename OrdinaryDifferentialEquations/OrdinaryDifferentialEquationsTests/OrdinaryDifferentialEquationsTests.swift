import XCTest
@testable import OrdinaryDifferentialEquations

final class OrdinaryDifferentialEquationsTests: XCTestCase {
  func testExample() throws {
    let input = MilneMethodInput(
      equation: { x, y in
        y + (1 + x) * y * y
      },
      interval: .init(1, 2),
      initialY: -1,
      stepLength: 0.1,
      tolerance: 0.001
    )

    try milne(input).forEach {
      print($0)
    }
  }
}
