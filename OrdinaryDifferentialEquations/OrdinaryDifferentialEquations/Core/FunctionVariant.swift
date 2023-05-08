import Foundation

enum FunctionVariant: Hashable, Equatable, CaseIterable, SelfIdentifiable {
  case first
  case second
  case third
}

extension FunctionVariant {
  var displayName: String {
    switch self {
    case .first:
      return "y' = 2xy"

    case .second:
      return "y' = 3.5x - y + x^2"

    case .third:
      return "y' = x - y + 1"
    }
  }
}

extension FunctionVariant {
  var equation: Function2 {
    switch self {
    case .first:
      return { x, y in
        2 * x * y
      }

    case .second:
      return { x, y in
        3.5 * x - y + pow(x, 2)
      }

    case .third:
      return { x, y in
        x - y + 1
      }
    }
  }
}

extension FunctionVariant {
  func solution(with point: Point) -> Function {
    let x0 = point.x
    let y0 = point.y

    switch self {
    case .first:
      // Common solution is:
      // y(x) = ce^(x^2)

      // Find c for point (x0, y0):
      // c = y0 / e^(x0^2)

      let c = y0 / exp(pow(x0, 2))
      return { x in
        c * exp(pow(x, 2))
      }

    case .second:
      // Common solution is:
      // y(x) = ce^(-x) + x^2 + 1.5x - 1.5

      // Find c for point (x0, y0):
      // c = (y0 - x0^2 - 1.5x0 + 1.5) / e^(-x0)

      let c = (y0 - pow(x0, 2) - 1.5 * x0 + 1.5) / exp(-x0)
      return { x in
        c * exp(-x) + pow(x, 2) + 1.5 * x - 1.5
      }

    case .third:
      // Common solution is:
      // y(x) = ce^(-x) + x

      // Find c for point (x0, y0):
      // c = (y0 - x0) / e^(-x0)

      let c = (y0 - x0) / exp(-x0)
      return { x in
        c * exp(-x) + x
      }
    }
  }
}

