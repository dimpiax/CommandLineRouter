# CommandLineRouter

[![Language](https://img.shields.io/badge/swift-3.0-fec42e.svg)](https://swift.org/blog/swift-3-0-released/)
[![License](https://img.shields.io/badge/license-MIT-333333.svg)](https://github.com/dimpiax/CommandLineRouter/blob/master/LICENSE)
[![Platform](https://img.shields.io/badge/platform-ios osx linux-999999.svg)](https://github.com/dimpiax/CommandLineRouter)

## Description
Library for easy and flexible manipulation with `CommandLine.arguments` in executable product of Swift Package Manager

## Usage
Run your executable product via SPM, and pass arguments
`$ .build/debug/Project -i input_file -o output_file`

## Result
Output:
```
read file input_file
write file output_file
```

# Example
```
import CommandLineRouter

var router = CommandLineRouter()

// setup routes
router.setCommands(name: "Save file", commands:
    Command(shortName: "-i", name: "--input"),
    Command(shortName: "-o", name: "--output")
)

router.setCommands(name: "Export in folder", commands:
    Command(shortName: "-i", name: "--input"),
    Command(shortName: "-of", name: "--output-folder")
)

// process routing
do {
    try router.route(CommandLine.arguments) { _, command, argument in
        switch command.shortName {
            case "-i":
                print("read file \(argument)")
            
            case "-o":
                print("write file \(argument)")
            
            default: break
        }
    }
} catch {
    print(error)
}
```
