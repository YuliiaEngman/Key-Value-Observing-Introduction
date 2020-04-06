import UIKit

//KVO - Key-Value observing

//KVO is part of the observing pattern
// NotificstionCenter is also an observer pattern

//KVO is a one-to many pattern relation as opposed to delegation which is one-to-one

//In the delegation patern
// class ViewController: UIViewController {}
// e.g. tableView.dataSource = self

// KVO is an Objective-C runtine API
// Alonge with KVO being an objective-c runtime some essentials are required
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NSObject, NSObject is the top abstract class in Obkective-C
// 3. Any property being marked for observation needs to be prefixed
// with @objc dynamic. Dynamic means that the property is being
// dynamically dispatched (at runtime the compiler verifies the underlying property).
// In Swift types are statically dispatched which means they are checked at compile time vs Objective-C wgich is dynamically dispached and checked at runtime.

// Statick vs dynamic dispatch

// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

//Dog class (class being observed) - will have a property to be observed:
//class inherits from NSObject

@objc class Dog: NSObject {
    var name: String = ""
    @objc dynamic var age: Int // age is observable property
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// Observer class one (these classes could be a view controllers)
class DogWalker {
    let dog: Dog
    var birthdayObseration: NSKeyValueObservation? // similar to listener at Firebase // a handle for the property being observed i.e. age property on Dog
    init(dog: Dog) {
        self.dog = dog
        // we need to call it here (or in view didLoad)
        configureBirthdayObservstion()
    }
    
    private func configureBirthdayObservstion() {
        // \.age is keyPath syntax for KVO
        birthdayObseration = dog.observe(\.age, options: [.old, .new], changeHandler:  { (dog, change) in
            // update ui accordingly if in a view contoller class
            guard let age = change.newValue else {
                return
            }
            print("Hey \(dog.name), happy \(age) birthday from the dog walker")
        })
    }
}


// Observer class two
class DogGroomer {
    let dog: Dog
    var birthdayObseration: NSKeyValueObservation? // similar to listener at Firebase // a handle for the property being observed i.e. age property on Dog
    init(dog: Dog) {
        self.dog = dog
        // we need to call it here (or in view didLoad)
        configureBirthdayObservstion()
    }
    
    private func configureBirthdayObservstion() {
        // \.age is keyPath syntax for KVO
        birthdayObseration = dog.observe(\.age, options: [.old, .new], changeHandler:  { (dog, change) in
            // unwrap the new value vhange since it is optional
            guard let age = change.newValue else {
                return
            }
            print("Hey \(dog.name), happy \(age) birthday from the dog walker")
            print("groomer old value: \(change.oldValue ?? 0)")
            print("groomer new value: \(change.newValue ?? 0)")
        })
    }
}

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy)
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1
 
