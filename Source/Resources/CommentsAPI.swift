//
//  Comments.swift
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
    fileprivate enum Comments: Resource {
        case byMediaID(String)
        case withID(mediaID: String, commentID: String)
        
        func uri() -> String {
            switch self {
            case .byMediaID(let mediaID):           return "/v1/media/\(mediaID)/comments"
            case .withID(let mediaID, let commentID): return "/v1/media/\(mediaID)/comments/\(commentID)"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func comments(mediaID ID: String, completion: @escaping (APIResult<Array<Comment>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Comments.byMediaID(ID), completion: completion)
    }
    
    @discardableResult
    public func postComment(_ comment: String, mediaID ID: String, completion: @escaping (APIResult<NoData>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent, Scope.comments]) { completion(Result.failure(error)); return nil }
        
        let params = [Param.commentText: comment]
        
        return post(API.Comments.byMediaID(ID), params: params, completion: completion)
    }
    
    @discardableResult
    public func deleteComment(mediaID: String, commentID: String, completion: @escaping (APIResult<NoData>) -> Void) -> URLSessionDataTask? {
        guard hasValidAccessToken(accessToken) else { completion(Result.failure(APIError.authenticationRequired(responseError: nil))); return nil }
        if let error = validateScopes([Scope.publicContent, Scope.comments]) { completion(Result.failure(error)); return nil }
        let apiResource = API.Comments.withID(mediaID: mediaID, commentID: commentID)
        guard let url = resource(apiResource, options: nil, parameters: [
            Param.accessToken.rawValue: accessToken!
        ]) else { completion(Result.failure(APIError.invalidURL(path: apiResource.uri()))); return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return fetch(request: request, completion: completion)
    }
}
