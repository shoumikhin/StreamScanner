//
//  Created by Anthony Shoumikhin on 6/25/15.
//  Copyright © 2015 shoumikh.in. All rights reserved.
//

import Foundation

public class StreamScanner
{
    public static let standardInput = StreamScanner(source: NSFileHandle.fileHandleWithStandardInput())
    private let source: NSFileHandle
    private let delimiters: NSCharacterSet
    private var buffer: NSScanner?

    public init(source: NSFileHandle, delimiters: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet())
    {
        self.source = source
        self.delimiters = delimiters
    }

    public func read<T>() -> T?
    {
        if buffer == nil || buffer!.atEnd
        {
            //init or append the buffer
            if let nextInput = NSString(data: source.availableData, encoding: NSUTF8StringEncoding)
            {
                buffer = NSScanner(string: nextInput as String)
            }
        }

        if buffer != nil
        {
            var token: NSString?

            //grab the next valid characters into token
            if buffer!.scanUpToCharactersFromSet(delimiters, intoString: &token) && token != nil
            {
                //skip delimiters for the next invocation
                buffer!.scanCharactersFromSet(delimiters, intoString: nil)

                //convert the token into an instance of type T and return it
                return convert(token as! String)
            }
        }

        return nil
    }

    private func convert<T>(token: String) -> T?
    {
        let scanner = NSScanner(string: token)
        var ret: T? = nil

        switch ret
        {
        case is String? :
            var value: NSString? = ""
            if scanner.scanString(token, intoString: &value)
            {
                ret = value as? T
            }
        case is Int? :
            var value: Int = 0
            if scanner.scanInteger(&value)
            {
                ret = value as? T
            }
        case is Int32? :
            var value: Int32 = 0
            if scanner.scanInt(&value)
            {
                ret = value as? T
            }
        case is Int64? :
            var value: Int64 = 0
            if scanner.scanLongLong(&value)
            {
                ret = value as? T
            }
        case is UInt64? :
            var value: UInt64 = 0
            if scanner.scanUnsignedLongLong(&value)
            {
                ret = value as? T
            }
        case is Float? :
            var value: Float = 0
            if scanner.scanFloat(&value)
            {
                ret = value as? T
            }
        case is Double? :
            var value: Double = 0
            if scanner.scanDouble(&value)
            {
                ret = value as? T
            }
        default :
            ret = nil
        }

        return ret
    }
}
