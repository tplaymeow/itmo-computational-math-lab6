import SwiftUI
import Charts

struct ContentView: View {
  var body: some View {
    VStack {
      if let errorMessage = self.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
          .bold()
      }

      Chart {
        ForEach(self.tableItems) {
          LineMark(
            x: .value("X", $0.x),
            y: .value("Y", $0.eulerY),
            series: .value("Type", "Euler Y")
          )
          .foregroundStyle(Color.red)

          LineMark(
            x: .value("X", $0.x),
            y: .value("Y", $0.modifiedEulerY),
            series: .value("Type", "Modified Euler Y")
          )
          .foregroundStyle(Color.yellow)

          LineMark(
            x: .value("X", $0.x),
            y: .value("Y", $0.rungeKuttaY),
            series: .value("Type", "Runge Kutta Y")
          )
          .foregroundStyle(Color.green)

          LineMark(
            x: .value("X", $0.x),
            y: .value("Y", $0.milneY),
            series: .value("Type", "Milne Y")
          )
          .foregroundStyle(Color.blue)

          LineMark(
            x: .value("X", $0.x),
            y: .value("Y", $0.y),
            series: .value("Type", "Y")
          )
          .foregroundStyle(Color.white)
        }
        .interpolationMethod(.cardinal)
      }
      .chartForegroundStyleScale([
        "Euler Y": Color.red,
        "Modified Euler Y": Color.yellow,
        "Runge Kutta Y": Color.green,
        "Milne Y": Color.blue,
        "Y": Color.white,
      ])


      Table(self.tableItems) {
        TableColumn("X") {
          Text($0.x.formatted())
        }

        TableColumn("Euler Y") {
          Text($0.eulerY.formatted())
        }

        TableColumn("Modified Euler Y") {
          Text($0.modifiedEulerY.formatted())
        }

        TableColumn("Runge-Kutta Y") {
          Text($0.rungeKuttaY.formatted())
        }

        TableColumn("Milne Y") {
          Text($0.milneY.formatted())
        }

        TableColumn("Y") {
          Text($0.y.formatted())
        }
      }

      if let errors = self.methodErrors {
        Text("Euler runge error: \(errors.euler.formatted())")
        Text("Modified Euler runge error: \(errors.modifiedEuler.formatted())")
        Text("Runge-Kutta runge error: \(errors.rungeKutta.formatted())")
        Text("Milne error: \(errors.milne.formatted())")
      }

      Form {
        Picker(
          "Function",
          selection: self.$functionVariant
        ) {
          ForEach(FunctionVariant.allCases) { variant in
            Text(variant.displayName).tag(variant)
          }
        }

        TextField(
          "Interval from",
          value: self.$intervalFrom,
          formatter: self.formatter
        )

        TextField(
          "Interval to",
          value: self.$intervalTo,
          formatter: self.formatter
        )

        TextField(
          "Step Length",
          value: self.$stepLength,
          formatter: self.formatter
        )

        TextField(
          "Tolerance",
          value: self.$tolerance,
          formatter: self.formatter
        )

        TextField(
          "y0",
          value: self.$initialY,
          formatter: self.formatter
        )

        Button("Calculate") {
          self.calculate()
        }
      }
    }
    .padding()
  }

  private struct TableItem: Hashable, SelfIdentifiable {
    let x: Double
    let y: Double
    let eulerY: Double
    let modifiedEulerY: Double
    let rungeKuttaY: Double
    let milneY: Double
  }

  private struct MethodErrors {
    let euler: Double
    let modifiedEuler: Double
    let rungeKutta: Double
    let milne: Double
  }

  @State
  private var functionVariant: FunctionVariant = .first
  @State
  private var intervalFrom: Double = 0.0
  @State
  private var intervalTo: Double = 10.0
  @State
  private var initialY: Double = 0.1
  @State
  private var stepLength: Double = 0.1
  @State
  private var tolerance: Double = 0.01

  @State
  private var tableItems: [TableItem] = []
  @State
  private var methodErrors: MethodErrors?
  @State
  private var errorMessage: String?

  private let formatter: NumberFormatter = {
    let result = NumberFormatter()
    result.maximumFractionDigits = 3
    return result
  }()

  private var commonInput: MethodInput {
    MethodInput(
      equation: self.functionVariant.equation,
      interval: .init(self.intervalFrom, self.intervalTo),
      initialY: self.initialY,
      stepLength: self.stepLength
    )
  }

  private var milneInput: MilneMethodInput {
    MilneMethodInput(
      equation: self.functionVariant.equation,
      interval: .init(self.intervalFrom, self.intervalTo),
      initialY: self.initialY,
      stepLength: self.stepLength,
      tolerance: self.tolerance
    )
  }

  private func calculate() {
    guard let milneOutput = try? milne(self.milneInput) else {
      self.tableItems = []
      self.methodErrors = nil
      self.errorMessage = "Step is too big"
      return
    }

    let initialPoint = Point(x: self.intervalFrom, y: self.initialY)
    let solution = self.functionVariant.solution(with: initialPoint)

    let milneError = milneOutput
      .map { abs(solution($0.x) - $0.y) }
      .max() ?? 0.0

    let eulerOutput = euler(self.commonInput)
    let eulerOutputX2 = euler(self.commonInput.increasedAccuracy())
    let eulerError = rungeRule(eulerOutput, eulerOutputX2, order: eulerOrder)

    let modifiedEulerOutput = modifiedEuler(self.commonInput)
    let modifiedEulerOutputX2 = modifiedEuler(self.commonInput.increasedAccuracy())
    let modifiedEulerError = rungeRule(modifiedEulerOutput, modifiedEulerOutputX2, order: modifiedEulerOrder)

    let rungeKuttaOutput = rungeKutta(self.commonInput)
    let rungeKuttaOutputX2 = rungeKutta(self.commonInput.increasedAccuracy())
    let rungeKuttaError = rungeRule(rungeKuttaOutput, rungeKuttaOutputX2, order: rungeKuttaOrder)

    self.tableItems = zip(
      eulerOutput,
      modifiedEulerOutput,
      rungeKuttaOutput,
      milneOutput
    ).map { euler, modifiedEuler, rungeKutta, milne in
      TableItem(
        x: euler.x,
        y: solution(euler.x),
        eulerY: euler.y,
        modifiedEulerY: modifiedEuler.y,
        rungeKuttaY: rungeKutta.y,
        milneY: milne.y
      )
    }

    self.methodErrors = .init(
      euler: eulerError,
      modifiedEuler: modifiedEulerError,
      rungeKutta: rungeKuttaError,
      milne: milneError
    )

    self.errorMessage = nil
  }
}
