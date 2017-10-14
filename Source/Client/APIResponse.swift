//
//  APIResponse.swift
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

public struct APIResponse<T> {
    public let meta: APIMetadata?
    public let data: T
    
    public init(meta: APIMetadata? = nil, data: T) {
        self.meta = meta
        self.data = data
    }
}

// MARK: Decodable

extension APIResponse where T:Decodable {
    public static func decode(_ json: Any) throws -> APIResponse {
        return APIResponse<T> (
            meta: try? APIMetadata.decode(json => "meta"),
            data: try T.decode(json => "data")
        )
    }
    
    public static func rawDecode(_ json: Any) throws -> APIResponse {
        return try APIResponse<T> (
            meta: nil,
            data: T.decode(json)
        )
    }
}
