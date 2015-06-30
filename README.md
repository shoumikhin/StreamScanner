# Input Stream Scanner
A simple scanner for any kind of input file streams with arbitrary delimiters. Made with Swift, based on `NSScanner`. 

Originally appeared as a necessity to parse the standard input for competitive programming challenges on [HackerRank](https://www.hackerrank.com/).<br>

## Installation

#### For competitive programming

Copy-paste the contents of this [tiny sample](https://github.com/shoumikhin/sample/blob/master/ACC.swift) and enjoy. 

For more complicated use cases check out the full version of [StreamScanner.swift](StreamScanner/StreamScanner.swift). See the [usage](#usage) and [examples](#more-examples) sections below.

#### As a framework

Compile, link against and don't forget to:

```swift
import StreamScanner
```

#### As a built-in class

Add [StreamScanner.swift](StreamScanner/StreamScanner.swift) file to your project.

## Usage

For convenience you can declare:

```swift
let stdin = StreamScanner.standardInput
```
and use `stdin` later on.

Spaces and new lines considered delimiters by default.

Customize with constructor like:

```swift
let stream = StreamScanner(source: NSFileHandle(forReadingAtPath: "/path/to/file"),
                           delimiters: NSCharacterSet(charactersInString: "-.:\n"))
```

Call `read()` to get the next value from a stream. It returns `Optional<T>` where `T` is a type of a variable where to `read()` the stream.

Imagine there's a file at `/path/to/file` with the following contents:

```
42.times show:not_a_double
```

And here's one of the ways to scan it with the `stream` declared above:

```swift
var number: Int? = stream.read()        //parse an integer at the current position in the stream, if possible
var string: String? = stream.read()     //now skip a delimiting dot and parse a string
var double: Double? = stream.read()     //now skip a delimiting colon and try to parse a double

print("\(number) \(string) \(double)")  //Optional(42) Optional("times show") nil
```

## More Examples

#### Read some arbitrary values of different type from the standard input

```swift
if
    let int: Int = stdin.read(),
    let string: String = stdin.read(),
    let double: Double = stdin.read(),
    let int64: Int64 = stdin.read(),
    let float: Float = stdin.read()
{
    print("\(int) \(string) \(double) \(int64) \(float)")
}
```
*Input:*
```
+42 st_ring!
-0.987654321 12345678900
.42
```
*Output:*
```
42 st_ring! -0.987654321 12345678900 0.42
```

#### Read an array of `Int64` of an arbitrary size from the standard input

```swift
if var count: Int = stdin.read()
{
    var array: [Int64] = []

    while Bool(count--)
    {
        if let integer: Int64 = stdin.read()
        {
            array.append(integer)
        }
    }

    print(array)
}
```
*Input:*
```
2
1234567890123456789 987654321098765432
```
*Output:*
```
[1234567890123456789, 987654321098765432]
```

#### Read and present the contents of [`/etc/passwd`](https://en.wikipedia.org/wiki/Passwd) file

```swift
if let input = NSFileHandle(forReadingAtPath: "/etc/passwd")
{
    let scanner = StreamScanner(source: input, delimiters: NSCharacterSet(charactersInString: ":\n"))

    print("User Database:")

    while let line: String = scanner.read()
    {
        //skip any comments
        if !line.hasPrefix("#")
        {
            let username = line

            if
                let valid: String = scanner.read(),
                let userId: Int = scanner.read(),
                let groupId: Int = scanner.read(),
                let gecos: String = scanner.read(),
                let home: String = scanner.read(),
                let shell: String = scanner.read()
            {
                print("------------------------------")
                print("User: \t\(username) (\(gecos))")
                print("UID:  \t\(userId)")
                print("GID:  \t\(groupId)")
                print("Home: \t\(home)")
                print("Shell:\t\(shell)")
            }
        }
    }
}
```
*Output:*
```
User Database:
------------------------------
User: 	nobody (Unprivileged User)
UID:  	-2
GID:  	-2
Home: 	/var/empty
Shell:	/usr/bin/false
------------------------------
User: 	root (System Administrator)
UID:  	0
GID:  	0
Home: 	/var/root
Shell:	/bin/sh
------------------------------
User: 	daemon (System Services)
UID:  	1
GID:  	1
Home: 	/var/root
Shell:	/usr/bin/false
```
## License

This toy is free and open.

[<img src="https://cloud.githubusercontent.com/assets/426434/8402001/9565ec3c-1deb-11e5-95a2-7d3ecdf08334.png" alt="Creative Commons" />](http://creativecommons.org)
