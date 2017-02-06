//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import XCTest
import StreamScanner

class StreamScannerTests: XCTestCase {
  let bundle = Bundle(for: StreamScannerTests.self)
  let filename = "samples/test"

  func testTypes() {
    let test = "types"
    if let inputFilename = bundle.path(forResource: filename, ofType: test+"_in"),
        let outputFilename = bundle.path(forResource: filename, ofType: test+"_out") {
      if let input = FileHandle(forReadingAtPath: inputFilename),
          let output = FileHandle(forReadingAtPath: outputFilename),
          let expected = String(data: output.readDataToEndOfFile(), encoding: .utf8) {
        let scanner = StreamScanner(source: input)
        if let int: Int = scanner.read(),
            let string: String = scanner.read(),
            let double: Double = scanner.read(),
            let int64: Int64 = scanner.read(),
            let float: Float = scanner.read() {
          let actual = "\(int) \(string) \(double) \(int64) \(float)"
          XCTAssertEqual(actual, expected as String)
          return
        }
      }
    }
    XCTFail()
  }

  func testDelimiters() {
    let test = "delimiters"
    if let inputFilename = bundle.path(forResource: filename, ofType: test+"_in"),
        let outputFilename = bundle.path(forResource: filename, ofType: test+"_out") {
      if let input = FileHandle(forReadingAtPath: inputFilename),
          let output = FileHandle(forReadingAtPath: outputFilename),
          let expected = String(data: output.readDataToEndOfFile(), encoding: .utf8) {
        let scanner = StreamScanner(source: input, delimiters: CharacterSet(charactersIn: ":\n"))
        if let string: String = scanner.read(),
            let double: Double = scanner.read(),
            let int: Int64 = scanner.read(),
            let string2: String = scanner.read(),
            let double2: Double = scanner.read(),
            let int2: Int64 = scanner.read() {
          let actual = "\(string) \(double) \(int) \(string2) \(double2) \(int2)"
          XCTAssertEqual(actual, expected as String)
          return
        }
      }
    }
    XCTFail()
  }

  func testGenerator() {
    let test = "generator"
    if let inputFilename = bundle.path(forResource: filename, ofType: test+"_in"),
        let outputFilename = bundle.path(forResource: filename, ofType: test+"_out") {
      if let input = FileHandle(forReadingAtPath: inputFilename),
          let output = FileHandle(forReadingAtPath: outputFilename),
          let expected = String(data: output.readDataToEndOfFile(), encoding: .utf8) {
        var delimiters = CharacterSet.whitespacesAndNewlines
        delimiters.formUnion(CharacterSet(charactersIn: ","))
        let scanner = StreamScanner(source: input, delimiters: delimiters)
        var names: [String] = []
        for name in scanner {
          names.append(name)
        }
        if !scanner.ready() {
          // If we really finished reading all the names from a file in the above for-in loop.
          names.sort() { $0 < $1 }
          let actual = names.joined(separator: ", ")
          XCTAssertEqual(actual, expected)
          return
        }
      }
    }
    XCTFail()
  }
}
