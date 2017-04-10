//
//  Tag.swift
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
import Decodable

public struct Tag {
    public let name: String
    public let mediaCount: Int
    
    public init(name: String, mediaCount: Int = 0) {
        self.name = name
        self.mediaCount = mediaCount
    }
}

// MARK: Equatable

extension Tag: Equatable {
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name && lhs.mediaCount == rhs.mediaCount
    }
}

// MARK: Hashable

extension Tag: Hashable {
    public var hashValue: Int {
        return name.hashValue ^ mediaCount.hashValue
    }
}

// MARK: Decodable

extension Tag: Decodable {
    public static func decode(_ json: Any) throws -> Tag {
        return try Tag(
            name: json => "name",
            mediaCount: json => "media_count"
        )
    }
}
