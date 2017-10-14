//
//  Caption.swift
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
import Decodable

public struct Caption {
    public let ID: String
    public let creationDate: Date
    public let text: String
    public let creator: User
    
    public init(ID: String, creationDate: Date, text: String, creator: User) {
        self.ID = ID
        self.creationDate = creationDate
        self.text = text
        self.creator = creator
    }
}

// MARK: Decodable

extension Caption: Decodable {
    public static func decode(_ json: Any) throws -> Caption {
        return try Caption(
            ID: json => "id",
            creationDate: json => "created_time",
            text: json => "text",
            creator: User.decode(json => "from")
        )
    }
}
