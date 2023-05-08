let eulerOrder: Int = 1

func euler(_ input: MethodInput) -> [Point] {
  var x = input.interval.from
  var y = input.initialY

  var result = [Point(x: x, y: y)]

  while x <= input.interval.to {
    let nextX = x + input.stepLength
    let nextY = y + input.stepLength * input.equation(x, y)

    result.append(Point(x: nextX, y: nextY))

    x = nextX
    y = nextY
  }

  return result
}
