//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import XCTest
import StreamScanner

class StreamScannerTests: XCTestCase
{
    let bundle = NSBundle(forClass: StreamScannerTests.self)
    let filename = "samples/test"

    func testTypes()
    {
        let test = "types"

        if
            let inputFilename = bundle.pathForResource(filename, ofType: test+"_in"),
            let outputFilename = bundle.pathForResource(filename, ofType: test+"_out")
        {
            if
                let input = NSFileHandle(forReadingAtPath: inputFilename),
                let output = NSFileHandle(forReadingAtPath: outputFilename),
                let expected = NSString(data: output.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
            {
                let scanner = StreamScanner(source: input)

                if
                    let int: Int = scanner.read(),
                    let string: String = scanner.read(),
                    let double: Double = scanner.read(),
                    let int64: Int64 = scanner.read(),
                    let float: Float = scanner.read()
                {
                    let actual = "\(int) \(string) \(double) \(int64) \(float)"

                    XCTAssertEqual(actual, expected)

                    return
                }
            }
        }

        XCTFail()
    }

    func testDelimiters()
    {
        let test = "delimiters"

        if
            let inputFilename = bundle.pathForResource(filename, ofType: test+"_in"),
            let outputFilename = bundle.pathForResource(filename, ofType: test+"_out")
        {
            if
                let input = NSFileHandle(forReadingAtPath: inputFilename),
                let output = NSFileHandle(forReadingAtPath: outputFilename),
                let expected = NSString(data: output.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
            {
                let scanner = StreamScanner(source: input, delimiters: NSCharacterSet(charactersInString: ":\n"))

                if
                    let string: String = scanner.read(),
                    let double: Double = scanner.read(),
                    let int: Int64 = scanner.read(),
                    let string2: String = scanner.read(),
                    let double2: Double = scanner.read(),
                    let int2: Int64 = scanner.read()
                {
                    let actual = "\(string) \(double) \(int) \(string2) \(double2) \(int2)"

                    XCTAssertEqual(actual, expected)

                    return
                }
            }
        }

        XCTFail()
    }

    func testGenerator()
    {
        let test = "generator"

        if
            let inputFilename = bundle.pathForResource(filename, ofType: test+"_in"),
            let outputFilename = bundle.pathForResource(filename, ofType: test+"_out")
        {
            if
                let input = NSFileHandle(forReadingAtPath: inputFilename),
                let output = NSFileHandle(forReadingAtPath: outputFilename),
                let expected = NSString(data: output.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
            {
                var delimiters = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()

                delimiters.formUnionWithCharacterSet(NSCharacterSet(charactersInString: ","))

                let scanner = StreamScanner(source: input, delimiters: delimiters)
                var names: [String] = []

                for name in scanner
                {
                    names.append(name)
                }

                if !scanner.ready()  //if we really finished reading all the names from a file in the above for-in loop
                {
                    names.sort() { $0 < $1 }

                    var actual = ", ".join(names)

                    XCTAssertEqual(actual, expected)
                    
                    return
                }
            }
        }
        
        XCTFail()
    }
}
