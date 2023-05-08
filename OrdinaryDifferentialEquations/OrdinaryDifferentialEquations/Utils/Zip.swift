//
//  Zip.swift
//  OrdinaryDifferentialEquations
//
//  Created by Timur Guliamov on 07.05.2023.
//

import Foundation

func zip<
  Sequence1: Sequence,
  Sequence2: Sequence,
  Sequence3: Sequence,
  Sequence4: Sequence
>(
  _ sequence1: Sequence1,
  _ sequence2: Sequence2,
  _ sequence3: Sequence3,
  _ sequence4: Sequence4
) -> Zip4Sequence<
  Sequence1,
  Sequence2,
  Sequence3,
  Sequence4
> {
  Zip4Sequence(
    sequence1,
    sequence2,
    sequence3,
    sequence4
  )
}

struct Zip4Sequence<
  Sequence1: Sequence,
  Sequence2: Sequence,
  Sequence3: Sequence,
  Sequence4: Sequence
>: Sequence {
  typealias Element = (
    Sequence1.Element,
    Sequence2.Element,
    Sequence3.Element,
    Sequence4.Element
  )

  init(
    _ sequence1: Sequence1,
    _ sequence2: Sequence2,
    _ sequence3: Sequence3,
    _ sequence4: Sequence4
  ) {
    self.sequence1 = sequence1
    self.sequence2 = sequence2
    self.sequence3 = sequence3
    self.sequence4 = sequence4
  }

  func makeIterator() -> AnyIterator<Element> {
    var iterator1 = self.sequence1.makeIterator()
    var iterator2 = self.sequence2.makeIterator()
    var iterator3 = self.sequence3.makeIterator()
    var iterator4 = self.sequence4.makeIterator()
    return AnyIterator {
      guard
        let e1 = iterator1.next(),
        let e2 = iterator2.next(),
        let e3 = iterator3.next(),
        let e4 = iterator4.next()
      else {
        return nil
      }
      return (e1, e2, e3, e4)
    }
  }

  private let sequence1: Sequence1
  private let sequence2: Sequence2
  private let sequence3: Sequence3
  private let sequence4: Sequence4
}
