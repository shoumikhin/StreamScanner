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

    func testSimple()
    {
        if
            let inputFilename = bundle.pathForResource(filename, ofType: "simple_in"),
            let outputFilename = bundle.pathForResource(filename, ofType: "simple_out")
        {
            if
                let input = NSFileHandle(forReadingAtPath: inputFilename),
                let output = NSFileHandle(forReadingAtPath: outputFilename),
                let reference = NSString(data: output.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
            {
                let scanner = StreamScanner(source: input)

                if
                    let int: Int = scanner.read(),
                    let string: String = scanner.read(),
                    let double: Double = scanner.read(),
                    let int64: Int64 = scanner.read(),
                    let float: Float = scanner.read()
                {
                    let result = "\(int) \(string) \(double) \(int64) \(float)"

                    XCTAssertEqual(result, reference)

                    return
                }
            }
        }

        XCTFail()
    }

    func testDelimiters()
    {
        if
            let inputFilename = bundle.pathForResource(filename, ofType: "delimiters_in"),
            let outputFilename = bundle.pathForResource(filename, ofType: "delimiters_out")
        {
            if
                let input = NSFileHandle(forReadingAtPath: inputFilename),
                let output = NSFileHandle(forReadingAtPath: outputFilename),
                let reference = NSString(data: output.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
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
                    let result = "\(string) \(double) \(int) \(string2) \(double2) \(int2)"

                    XCTAssertEqual(result, reference)

                    return
                }
            }
        }

        XCTFail()
    }
}
