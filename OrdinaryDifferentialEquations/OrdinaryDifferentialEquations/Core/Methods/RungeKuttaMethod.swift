let rungeKuttaOrder: Int = 4

func rungeKutta(_ input: MethodInput) -> [Point] {
  var x = input.interval.from
  var y = input.initialY

  var result = [Point(x: x, y: y)]

  while x <= input.interval.to {
    let nextX = x + input.stepLength
    let k1 = input.stepLength * input.equation(x, y)
    let k2 = input.stepLength * input.equation(
      x + input.stepLength / 2,
      y + k1 / 2)
    let k3 = input.stepLength * input.equation(
      x + input.stepLength / 2,
      y + k2 / 2)
    let k4 = input.stepLength * input.equation(
      x + input.stepLength,
      y + k3)
    let nextY = y + 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)

    result.append(Point(x: nextX, y: nextY))

    x = nextX
    y = nextY
  }

  return result
}
