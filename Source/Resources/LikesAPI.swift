//
//  Likes.swift
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
    fileprivate enum Likes: Resource {
        case byMediaID(String)
        
        func uri() -> String {
            switch self {
            case .byMediaID(let mediaID):   return "/v1/media/\(mediaID)/likes"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func likes(mediaID ID: String, completion: @escaping (APIResult<Array<Like>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Likes.byMediaID(ID), completion: completion)
    }
    
    @discardableResult
    public func like(mediaID ID: String, completion: @escaping (APIResult<NoData>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.publicContent, Scope.likes]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Likes.byMediaID(ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return fetch(request: request, completion: completion)
    }
    
    @discardableResult
    public func unlike(mediaID ID: String, completion: @escaping (APIResult<NoData>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.publicContent, Scope.likes]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Likes.byMediaID(ID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return fetch(request: request, completion: completion)
    }
}
