# RealmManager

RealmManager is an easy way of managing Realms objects.

## Features

- [x] Protocol oriented Realms
- [x] Easily create, save, delete, update your Realm Object Classes synchronously.
- [x] Access delegate methods as "willDeleteOnRealm" or "didMakeARealmCall" in a Swifty familiar way.
- [x] No more thread problems.

## How it works

Let's take as an example the User class, ready to be persisted on Realm.

```swift

class User: Object {
   ...
}
```

If you want to use the RealmManager methods, you just have to make it inherit from PersistableOnRealm. 
The protocol just needs the path where you want to save the Realm file.

```swift
extension User: PersistableOnRealm {

  static var realmPath: RealmPath {
    return Realms.users
  }
}
```

That you can privide from an enum of all the Realms used by your application.

```swift
enum Realms: String, RealmPath {

  case users
  
  var pathComponent: String {
    return .rawValue
  }
}
```

Now, the object is ready to be persisted!

```swift
let user = User()

try user.save()
try user.delete()

try user.update() {
  ...
}
```

## Requirements

- iOS 10.0+
- Xcode 10+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate RealmManager into your Xcode project using CocoaPods, specify it in your `Podfile`:

(TODO, to be integrated yet)
```ruby
TODO 
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate RealmManager into your project manually.

## Communication
- If you **need help** using Realm, contact Realm [or check their documentation](https://realm.io/docs/swift/latest/).
- If you need to **find or understand an API**, contact me (a better documentation is work in progress).
- If you **found a bug**, open an issue here on GitHub and follow the guide. The more detail the better!
- If you **want to contribute**, submit a pull request.
  
## FAQ

### Why a manager?

We all know that Realm is synonymous with simple and fast, but while working on my projects I wanted to find a way to make it even easier and faster, with an eye to the frequent bugs related to background threads. I am aware of the fact that it is not a complex library, but it should make its own in projects of not large dimensions.

## Credits

I DON'T own ANYTHING about Realm. This is just a manager which wrap Realm classes. For any informations about Realm, [contact them or look at their website](https://realm.io).
RealmManager is owned and maintained by Luca Celiento. You can follow me on Twitter at [@lookatlooka](https://twitter.com/lookatlooka) for project updates, advices and releases.

### Security Disclosure

If you believe you have identified a security vulnerability with RealmManager, please report it as soon as possible.

## License

RealmManager is released under the MIT license.
