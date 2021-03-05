//
//  Either.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import Foundation

public enum Either<A, B> {
    case left(A)
    case right(B)
    
    public var left: A? {
        switch self {
        case .left(let value):
            return value
        case .right:
            return nil
        }
    }
    
    public var right: B? {
        switch self {
        case .left:
            return nil
        case .right(let value):
            return value
        }
    }
    
    /// Applies the transform function to the `.left` value, if it is set.
    ///
    ///     let e = Either<String, Int>.left("hello")
    ///     let g = e.mapLeft { $0 + " world" }
    ///     let h = g.mapRight { $0 + 1 }
    ///     g == h == .left("hello world")
    ///
    /// - Parameter transform: The transformative function.
    /// - Returns: A transformed `Either`.
    public func mapLeft<R>(_ transform: (A) throws -> R) rethrows -> Either<R, B> {
        switch self {
        case .left(let a):
            return try .left(transform(a))
        case .right(let b):
            return .right(b)
        }
    }
    
    /// Applies the transform function to the `.right` value, if it is set.
    ///
    ///     let e = Either<String, Int>.right(10)
    ///     let g = e.mapLeft { $0 + " world" }
    ///     let h = g.mapRight { $0 + 1 }
    ///     g == h == .right(11)
    ///
    /// - Parameter transform: The transformative function.
    /// - Returns: A transformed `Either`.
    public func mapRight<R>(_ transform: (B) throws -> R) rethrows -> Either<A, R> {
        switch self {
        case .left(let a):
            return .left(a)
        case .right(let b):
            return try .right(transform(b))
        }
    }
    
    /// Applies the transform function to the `.left` value, if it is set.
    ///
    ///     let e = Either<String, Int>.left("hello")
    ///     let g = e.flatMapLeft { .left([$0]) }
    ///     g == .left(["hello"])
    ///
    /// - Parameter transform: The transformative function.
    /// - Returns: A transformed `Either`.
    public func flatMapLeft<R>(_ transform: (A) throws -> Either<R, B>) rethrows -> Either<R, B> {
        switch self {
        case .left(let a):
            return try transform(a)
        case .right(let b):
            return .right(b)
        }
    }
    
    /// Applies the transform function to the `.right` value, if it is set.
    ///
    ///     let e = Either<String, Int>.right(10)
    ///     let g = e.flatMapRight { .left(String($0) + " world") }
    ///     g == .left("10 world")
    ///
    /// - Parameter transform: The transformative function.
    /// - Returns: A transformed `Either`.
    public func flatMapRight<R>(_ transform: (B) throws -> Either<A, R>) rethrows -> Either<A, R> {
        switch self {
        case .left(let a):
            return .left(a)
        case .right(let b):
            return try transform(b)
        }
    }
}

public extension Either where A == B {
    
    /// Consolidate into the underlying concrete type when both types match.
    ///
    ///     let e = Either<String, Int>.right(10)
    ///     let f = e.mapLeft { Int($0) ?? 0 }
    ///     let g = e.mapRight { String($0) + " world" }
    ///     f.consolidated == 10
    ///     g.consolidated == "10 world"
    ///
    /// - Returns: The contained value, whether `.left` or `.right`.
    var consolidated: A {
        switch self {
        case .left(let a):
            return a
        case .right(let b):
            return b
        }
    }
}

extension Either: Equatable where A: Equatable, B: Equatable {
    public static func == (lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
        switch (lhs, rhs) {
        case (.left(let x), .left(let y)):
            return x == y
        case (.right(let x), .right(let y)):
            return x == y
        default:
            return false
        }
    }
}

extension Either: Decodable where A: Decodable, B: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try (try? container.decode(A.self)).map(Either.left) ?? .right(container.decode(B.self))
    }
}

extension Either: Encodable where A: Encodable, B: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .left(let left):
            try container.encode(left)
        case .right(let right):
            try container.encode(right)
        }
    }
}
