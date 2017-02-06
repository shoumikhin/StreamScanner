//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import Foundation

public protocol Scannable {}

extension String: Scannable {}
extension Int: Scannable {}
extension Int32: Scannable {}
extension Int64: Scannable {}
extension UInt64: Scannable {}
extension Float: Scannable {}
extension Double: Scannable {}

public final class StreamScanner : IteratorProtocol, Sequence {

  public static let standardInput = StreamScanner(source: FileHandle.standardInput)

  public init(source: FileHandle, delimiters: CharacterSet = CharacterSet.whitespacesAndNewlines) {
    self.source = source
    self.delimiters = delimiters
  }

  public func next() -> String? {
    return read()
  }

  public func makeIterator() -> Self {
    return self
  }

  public func ready() -> Bool {
    if buffer?.isAtEnd ?? true {
      // Init or append the buffer.
      let availableData = source.availableData
      if availableData.count > 0,
          let nextInput = String(data: availableData, encoding: .utf8) {
        buffer = Scanner(string: nextInput)
      }
    }
    return !(buffer?.isAtEnd ?? true)
  }

  public func read<T: Scannable>() -> T? {
    if ready() {
      var token: NSString?
      // Grab the next valid characters into token.
      if buffer?.scanUpToCharacters(from: delimiters, into: &token) ?? false,
          let token = token as? String {
        // Skip delimiters for the next invocation.
        buffer?.scanCharacters(from: delimiters, into: nil)
        // Convert the token into an instance of type T and return it.
        return convert(token)
      }
    }
    return nil
  }

  // MARK: - Private

  fileprivate let source: FileHandle
  fileprivate let delimiters: CharacterSet
  fileprivate var buffer: Scanner?

  fileprivate func convert<T: Scannable>(_ token: String) -> T? {
    let scanner = Scanner(string: token)
    switch T.self {
    case is String.Type:
      return token as? T
    case is Int.Type:
      var value: Int = 0
      if scanner.scanInt(&value) {
        return value as? T
      }
    case is Int32.Type:
      var value: Int32 = 0
      if scanner.scanInt32(&value) {
        return value as? T
      }
    case is Int64.Type:
      var value: Int64 = 0
      if scanner.scanInt64(&value) {
        return value as? T
      }
    case is UInt64.Type:
      var value: UInt64 = 0
      if scanner.scanUnsignedLongLong(&value) {
        return value as? T
      }
    case is Float.Type:
      var value: Float = 0
      if scanner.scanFloat(&value) {
        return value as? T
      }
    case is Double.Type:
      var value: Double = 0
      if scanner.scanDouble(&value) {
        return value as? T
      }
    default:
      break
    }
    return nil
  }
}
