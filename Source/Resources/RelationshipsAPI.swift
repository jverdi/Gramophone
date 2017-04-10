//
//  Relationships.swift
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
    fileprivate enum Relationships: Resource {
        case myFollows
        case myFollowers
        case myRequests
        case relationship(withUserID: String)
        
        func uri() -> String {
            switch self {
            case .myFollows:                        return "/v1/users/self/follows"
            case .myFollowers:                      return "/v1/users/self/followed-by"
            case .myRequests:                       return "/v1/users/self/requested-by"
            case .relationship(let userID):         return "/v1/users/\(userID)/relationship"
            }
        }
    }
}
extension Client {
    fileprivate static let relationshipActionFollowValue =      "follow"
    fileprivate static let relationshipActionUnfollowValue =    "unfollow"
    fileprivate static let relationshipActionApproveValue =     "approve"
    fileprivate static let relationshipActionIgnoreValue =      "ignore"
    
    @discardableResult
    public func myFollows(completion: @escaping (APIResult<Array<User>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.followerList]) { completion(Result.failure(error)); return nil }
        return get(API.Relationships.myFollows, completion: completion)
    }
    
    @discardableResult
    public func myFollowers(completion: @escaping (APIResult<Array<User>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.followerList]) { completion(Result.failure(error)); return nil }
        return get(API.Relationships.myFollowers, completion: completion)
    }
    
    @discardableResult
    public func myRequests(completion: @escaping (APIResult<Array<User>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.followerList]) { completion(Result.failure(error)); return nil }
        return get(API.Relationships.myRequests, completion: completion)
    }
    
    @discardableResult
    public func relationship(withUserID ID: String, completion: @escaping (APIResult<IncomingRelationship>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.followerList]) { completion(Result.failure(error)); return nil }
        return get(API.Relationships.relationship(withUserID: ID), completion: completion)
    }
    
    @discardableResult
    public func followUser(withID ID: String, completion: @escaping (APIResult<OutgoingRelationship>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.relationships]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Relationships.relationship(withUserID: ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = [ Param.relationshipAction.rawValue: Client.relationshipActionFollowValue ]
        if let queryItems = queryItems(options: nil, parameters: parameters), queryItems.count > 0 {
            var components = URLComponents()
            components.queryItems = queryItems
            if let postString = components.query {
                request.httpBody = postString.data(using: .utf8)
            }
        }
        return fetch(request: request, completion: completion)
    }
    
    @discardableResult
    public func unfollowUser(withID ID: String, completion: @escaping (APIResult<OutgoingRelationship>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.relationships]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Relationships.relationship(withUserID: ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = [ Param.relationshipAction.rawValue: Client.relationshipActionUnfollowValue ]
        if let queryItems = queryItems(options: nil, parameters: parameters), queryItems.count > 0 {
            var components = URLComponents()
            components.queryItems = queryItems
            if let postString = components.query {
                request.httpBody = postString.data(using: .utf8)
            }
        }
        return fetch(request: request, completion: completion)
    }
    
    @discardableResult
    public func approveUser(withID ID: String, completion: @escaping (APIResult<IncomingRelationship>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.relationships]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Relationships.relationship(withUserID: ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = [ Param.relationshipAction.rawValue: Client.relationshipActionApproveValue ]
        if let queryItems = queryItems(options: nil, parameters: parameters), queryItems.count > 0 {
            var components = URLComponents()
            components.queryItems = queryItems
            if let postString = components.query {
                request.httpBody = postString.data(using: .utf8)
            }
        }
        return fetch(request: request, completion: completion)
    }
    
    @discardableResult
    public func ignoreUser(withID ID: String, completion: @escaping (APIResult<IncomingRelationship>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.relationships]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Relationships.relationship(withUserID: ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = [ Param.relationshipAction.rawValue: Client.relationshipActionIgnoreValue ]
        if let queryItems = queryItems(options: nil, parameters: parameters), queryItems.count > 0 {
            var components = URLComponents()
            components.queryItems = queryItems
            if let postString = components.query {
                request.httpBody = postString.data(using: .utf8)
            }
        }
        return fetch(request: request, completion: completion)
    }
}
