enum MilneMethodError: Error {
  case incorrectPointsCount
}

let milneOrder: Int = 4

func milne(_ input: MilneMethodInput) throws -> [Point] {
  let rungeInput = input.with(pointsCount: 4)
  let rungePoints = rungeKutta(rungeInput)

  guard input.interval.to > rungeInput.interval.to else {
    throw MilneMethodError.incorrectPointsCount
  }

  guard var point = rungePoints.last else {
    throw MilneMethodError.incorrectPointsCount
  }

  var points = rungePoints
  var fs = points.map { input.equation($0.x, $0.y) }

  while point.x < input.interval.to {
    let x = point.x + input.stepLength

    let y2 = points[back: 2].y
    let y4 = points[back: 4].y

    let f1 = fs[back: 1]
    let f2 = fs[back: 2]
    let f3 = fs[back: 3]

    var predicted = y4 + 4 / 3 * input.stepLength * (2 * f3 - f2 + 2 * f1)

    while true {
      let f = input.equation(x, predicted)
      let corrected = y2 + input.stepLength / 3 * (f2 + 4 * f1 + f)

      if abs(predicted - corrected) > input.tolerance {
        predicted = corrected
      } else {
        break
      }
    }

    point = Point(x: x, y: predicted)
    points.append(point)
    fs.append(input.equation(x, predicted))
  }

  return points
}
