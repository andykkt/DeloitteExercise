//
//  Sequence++.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

public extension Sequence {
    
    /// Returns the first element in `self` that matches the given type, or `nil`.
    
    func first<T>(withTypeMatching _: T.Type) -> T? {
        return firstNonNil { $0 as? T }
    }
    
    /// Returns the first element in `self` that `transform` maps to a non-`nil` `Optional`.
    
    func firstNonNil<T>(_ transform: (Iterator.Element) throws -> T?) rethrows -> T? {
        var returnValue: T?
        for value in self {
            if let value = try transform(value) {
                returnValue = value
                break
            }
        }
        return returnValue
    }
    
    /// Returns `true` iff all elements in `self` satisfy `predicate`.
    
    func all(where predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool {
        var returnValue = true
        for value in self {
            if try !predicate(value) {
                returnValue = false
                break
            }
        }
        return returnValue
    }
    
    /// Returns `true` iff no elements in `self` satisfy `predicate`.
    
    func none(where predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool {
        return try !contains(where: predicate)
    }
    
    /// Returns the number of elements in in `self` that satisfy `predicate`.
    
    func count(where predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }

    /// Creates a sequence of values by continuously applying the `combine`
    /// function with the latest returned value as the input.
    ///
    ///     let g = (1...5).scan(0, +)
    ///     g == [0, 1, 3, 6, 10, 15]
    ///
    /// - Parameter initial: The initial value,
    ///   which will be at the start of the returned array.
    /// - Parameter combine: The combinator function.
    /// - Returns: An array with a successsive list of reduced values.
    func scan<T>(_ initial: T, _ combine: (T, Iterator.Element) -> T) -> [T] {
        var scannedValue = initial
        return [initial] + map {
            scannedValue = combine(scannedValue, $0)
            return scannedValue
        }
    }
}

public extension LazySequence {
    /// Create an infinitely repeating sequence of values identical to `value`.
    ///
    ///     let names = ["Jane", "Jack", "Gwynne", "Micky"]
    ///     let hellos = LazySequence(repeating: "Hello")
    ///     let g = zip(hellos, names).map { "\($0), \($1)" }
    ///     g == ["Hello, Jane", "Hello, Jack", "Hello, Gwynne", "Hello, Micky"]
    ///
    /// - Parameter repeating: `repeating` takes the element to be repeated.
    /// - Returns: An infinite lazy sequence of `value`.
    init<T>(repeating value: T) where Base == AnyIterator<T> {
        self = AnyIterator { value }.lazy
    }
}
