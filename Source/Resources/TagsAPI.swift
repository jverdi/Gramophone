//
//  Tags.swift
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
    fileprivate enum Tags: Resource {
        case byName(String)
        case recentMedia(String)
        case search
        
        func uri() -> String {
            switch self {
            case .byName(let name):         return "/v1/tags/\(name)"
            case .recentMedia(let name):    return "/v1/tags/\(name)/media/recent"
            case .search:                   return "/v1/tags/search"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func tag(name: String, completion: @escaping (APIResult<Tag>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Tags.byName(name), completion: completion)
    }
    
    @discardableResult
    public func tagRecentMedia(name: String, options: RequestOptions?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Tags.recentMedia(name), options: options, completion: completion)
    }
    
    @discardableResult
    public func tags(query: String, options: RequestOptions?, completion: @escaping (APIResult<Array<Tag>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        
        let params = [Param.searchQuery: query]
        
        return get(API.Tags.search, params: params, options: options, completion: completion)
    }
}
