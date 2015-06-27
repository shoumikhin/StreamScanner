//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import XCTest
import StreamScanner

class StreamScannerTests: XCTestCase
{
    let bundle = NSBundle(forClass: StreamScannerTests.self)
    let filename = "test"

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
                    let int: Int = scanner.next(),
                    let string: String = scanner.next(),
                    let double: Double = scanner.next(),
                    let int64: Int64 = scanner.next(),
                    let float: Float = scanner.next()
                {
                    let result = "\(int) \(string) \(double) \(int64) \(float)"

                    XCTAssertEqual(result, reference)

                    return
                }
            }
        }

        XCTFail()
    }
}
