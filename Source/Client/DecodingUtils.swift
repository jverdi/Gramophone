//
//  Array.swift
//  Gramophone
//
//  Copyright (c) 2017 Jared Verdi. All Rights Reserved
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import protocol Decodable.Decodable
import protocol Decodable.DynamicDecodable
import Decodable

public struct Array<T: Decodable>: Decodable {
    
    /// The resources which are part of the given array
    public let items: [T]
    
    internal static func parseItems(json: Any) throws -> [T] {
        return try (json as! [AnyObject]).flatMap {
            return try T.decode($0)
        }
    }
    public static func decode(_ json: Any) throws -> Array<T> {
        return try Array(items: parseItems(json: json).flatMap{ $0 })
    }
}

extension UInt: Decodable, DynamicDecodable {
    public static var decoder: (Any) throws -> UInt = { try cast($0) }
}

extension Data: Decodable, DynamicDecodable {
    public static var decoder: (Any) throws -> Data = { try cast($0) }
}

extension URL {
    public static var decoder: (Any) throws -> URL = { object in
        let string = try String.decode(object)
        guard let url = URL(string: string) else {
            let metadata = DecodingError.Metadata(object: object)
            throw DecodingError.rawRepresentableInitializationError(rawValue: string, metadata)
        }
        return url
    }
}
