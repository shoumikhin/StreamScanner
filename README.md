# StreamScanner
A simple scanner for any kind of file streams with arbitrary delimiters in Swift.<br/>
Originally appeared as a necessity to parse standard input for competitive programming challenges on [HackerRank](https://www.hackerrank.com/).<br>

## Installation

#### For competitive programming

Copy-paste the contents of [StreamScanner.swift](StreamScanner/StreamScanner.swift) to your solution file, read the [usage](#usage) section below and enjoy.

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

Spaces and new lines considered delimiters by default: customize with constructor like:

```swift
let input = StreamScanner(source: NSFileHandle(forReadingAtPath: "/path/to/file"),
                          delimiters: NSCharacterSet(charactersInString: "-.:\n"))
```

#### Read some arbitrary values of different type from a standard input

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

#### Read an array of `Int64` of a particular size

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
        //skip comments
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
