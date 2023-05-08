import Foundation

func rungeRule(_ a: Double, _ a2: Double, order: Int) -> Double {
  (a - a2) / (pow(2, Double(order)) - 1)
}

func rungeRule(_ a: [Point], _ a2: [Point], order: Int) -> Double {
  zip(a, a2)
    .map { rungeRule($0.y, $1.y, order: order) }
    .max() ?? 0
}
