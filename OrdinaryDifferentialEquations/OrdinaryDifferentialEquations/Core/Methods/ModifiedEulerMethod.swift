let modifiedEulerOrder: Int = 2

func modifiedEuler(_ input: MethodInput) -> [Point] {
  var x = input.interval.from
  var y = input.initialY

  var result = [Point(x: x, y: y)]

  while x <= input.interval.to {
    let nextX = x + input.stepLength
    let f0 = input.equation(x, y)
    let f1 = input.equation(nextX, y + input.stepLength * f0)
    let nextY = y + input.stepLength / 2 * (f0 + f1)

    result.append(Point(x: nextX, y: nextY))

    x = nextX
    y = nextY
  }

  return result
}
