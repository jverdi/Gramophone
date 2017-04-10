//
//  Users.swift
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
    fileprivate enum Users: Resource {
        case me
        case withID(String)
        case myRecentMedia
        case recentMediawithID(String)
        case myLikedMedia
        case search
        
        func uri() -> String {
            switch self {
            case .me:                           return "/v1/users/self"
            case .withID(let userID):             return "/v1/users/\(userID)"
            case .myRecentMedia:                return "/v1/users/self/media/recent"
            case .recentMediawithID(let userID):  return "/v1/users/\(userID)/media/recent"
            case .myLikedMedia:                 return "/v1/users/self/media/liked"
            case .search:                       return "/v1/users/search"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func me(completion: @escaping (APIResult<User>) -> Void) -> URLSessionDataTask? {
        return get(API.Users.me, completion: completion)
    }
    
    @discardableResult
    public func user(withID ID: String, completion: @escaping (APIResult<User>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Users.withID(ID), completion: completion)
    }
    
    @discardableResult
    public func myRecentMedia(options: RequestOptions?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        return get(API.Users.myRecentMedia, options: options, completion: completion)
    }
    
    @discardableResult
    public func userRecentMedia(withID ID: String, options: RequestOptions?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Users.recentMediawithID(ID), options: options, completion: completion)
    }
    
    @discardableResult
    public func myLikedMedia(options: RequestOptions?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Users.myLikedMedia, options: options, completion: completion)
    }
    
    @discardableResult
    public func users(query: String, options: RequestOptions?, completion: @escaping (APIResult<Array<User>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Users.search, params: [ Param.searchQuery: query], options: options, completion: completion)
    }
}
