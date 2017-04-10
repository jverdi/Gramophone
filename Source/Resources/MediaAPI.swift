//
//  Media.swift
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
import Result

extension Client.API {
    enum Media: Resource {
        case withID(String)
        case byShortcode(String)
        case search
        
        func uri() -> String {
            switch self {
            case .withID(let mediaID):            return "/v1/media/\(mediaID)"
            case .byShortcode(let shortcode):   return "/v1/media/shortcode/\(shortcode)"
            case .search:                       return "/v1/media/search"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func media(withID ID: String, completion: @escaping (APIResult<Media>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Media.withID(ID), completion: completion)
    }
    
    @discardableResult
    public func media(withShortcode shortcode: String, completion: @escaping (APIResult<Media>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Media.byShortcode(shortcode), completion: completion)
    }
    
    @discardableResult
    public func media(latitude: Double, longitude: Double, distanceInMeters: Double?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        
        var params = [
            Param.latitude: latitude,
            Param.longitude: longitude
        ]
        if let distanceInMeters = distanceInMeters {
            params[Param.distance] = distanceInMeters
        }
        
        return get(API.Media.search, params: params, completion: completion)
    }
}
