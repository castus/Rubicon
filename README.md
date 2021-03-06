<p align="center">
  <a href="https://github.com/raptorxcz/Rubicon">
      <img src="RubiconApp/Assets.xcassets/AppIcon.appiconset/Mac_256pt.png" alt="Rubicon" srcset="RubiconApp/Assets.xcassets/AppIcon.appiconset/Mac_256pt@2x.png 2x" />
    </a>
</p>

# Rubicon
[![Build Status](https://travis-ci.org/raptorxcz/Rubicon.svg?branch=master)](https://travis-ci.org/raptorxcz/Rubicon)
[![Build Status](https://codecov.io/gh/raptorxcz/Rubicon/branch/master/graph/badge.svg)](https://codecov.io/gh/raptorxcz/Rubicon)

**Again available on AppStore [https://itunes.apple.com/cz/app/rubicon/id1453837387](https://itunes.apple.com/cz/app/rubicon/id1453837387)**

Swift parser + mock generator

Rubicon generates spys for protocol. Generating methods for parent protocol is not supported.

## Example

input:

```swift

protocol Car {

    var name: String? { get }
    var color: Int { get set }

    func go()
    func load(with stuff: Int, label: String) throws -> Int
    func isFull() -> Bool

}

```

### Spy

output:

```swift

class CarSpy: Car {

    var name: String?
    var color: Int

    struct Load {
        let stuff: Int
        let label: String
    }

    var goCount = 0
    var load = [Load]()
    var isFullCount = 0
    var isFullReturn: Bool

    init(color: Int, isFullReturn: Bool) {
        self.color = color
        self.isFullReturn = isFullReturn
    }

    func go() {
        goCount += 1
    }

    func load(with stuff: Int, label: String) {
        let item = Load(stuff: stuff, label: label)
        load.append(item)
    }

    func isFull() -> Bool {
        isFullCount += 1
        return isFullReturn
    }
}

```

### Mock

output:

```swift

class CarStub: Car {

    var name: String?
    var color: Int

    var isFullReturn: Bool

    init(color: Int, isFullReturn: Bool) {
        self.color = color
        self.isFullReturn = isFullReturn
    }

    func go() {
    }

    func load(with stuff: Int, label: String) {
    }

    func isFull() -> Bool {
        return isFullReturn
    }
}

```

### Dummy

output:

```swift

class CarDummy: Car {

    var name: String? {
        fatalError()
    }
    var color: Int {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    func go() {
        fatalError()
    }

    func load(with stuff: Int, label: String) {
        fatalError()
    }

    func isFull() -> Bool {
        fatalError()
    }
}

```

### Usage in tests:

```swift
let carSpy = CarSpy()

...

XCTAssertEqual(carSpy.goCount, 1)
XCTAssertEqual(carSpy.load.count, 1)
XCTAssertEqual(carSpy.load[0].stuff, 2)
XCTAssertEqual(carSpy.load[0].label, "name")
```

## CLI

Rubicon cli can generate mocks for every protocol in folder. Script runs through every swift file and find every protocol definition. Result is printed at standard out.

example:

```
$ ./rubicon --spy .
```

### Options:

`--mocks path` - generates spies (deprecated)

`--spy path` - generates spies

`--stub path` - generates stubs

`--dummy path` - generates dummies

## Xcode extension

Xcode extension can generate Spy for every or selected `protocol`  in current file. Spy can be written to source file or pasteboard.

