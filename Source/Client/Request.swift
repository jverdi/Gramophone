//
//  Request.swift
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
import Result

extension Client {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    @discardableResult
    func request<DecodableType: Decodable>(method: HTTPMethod, apiResource: Resource, params: [Param: Any]? = nil, options: RequestOptions? = nil, completion: @escaping (APIResult<DecodableType>) -> Void) -> URLSessionDataTask? {
    
        guard hasValidAccessToken(accessToken) else {
            completion(Result.failure(APIError.authenticationRequired(responseError: nil)));
            return nil
        }
        
        var parameters: [String: Any] = [ Param.accessToken.rawValue: accessToken! ]
        params?.forEach{ parameters[$0.rawValue] = $1 }
        
        guard let url = resource(apiResource, options: options, parameters: parameters) else {
            completion(Result.failure(APIError.invalidURL(path: apiResource.uri())));
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if .post == method || .delete == method {
            if let queryItems = queryItems(options: nil, parameters: parameters), queryItems.count > 0 {
                var components = URLComponents()
                components.queryItems = queryItems
                if let postString = components.query {
                    request.httpBody = postString.data(using: .utf8)
                }
            }
        }
        
        return fetch(request: request, completion: completion)
    }
    
    @discardableResult
    func fetch<DecodableType: Decodable>(request: URLRequest, completion: @escaping (APIResult<DecodableType>) -> Void) -> URLSessionDataTask {
        return fetch(request: request) { result, response in
            DispatchQueue.main.async {
                switch result {
                case Result.success(let data): self.handleJSON(data.data, response, completion)
                case Result.failure(let error): completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    func fetch(request: URLRequest, completion: @escaping (APIResult<Data>, URLResponse?) -> Void) -> URLSessionDataTask {
        var req = request
        if let accessToken = accessToken {
            req = addAccessToken(accessToken, toRequest: req)
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                completion(Result.success(APIResponse<Data>(data: data)), response)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, let error = self?.serverError(forStatusCode: httpResponse.statusCode) {
                completion(Result.failure(error), response)
                return
            }
            
            if let error = error {
                completion(Result.failure(APIError.unknownError(responseError: error)), response)
                return
            }
            
            let apiError = APIError.invalidHTTPResponse(response: response)
            completion(Result.failure(apiError), response)
        }
        
        task.resume()
        return task
    }
    
    func addAccessToken(_ accessToken: String, toRequest request: URLRequest) -> URLRequest {
        var req = request
        var headerFields = req.allHTTPHeaderFields ?? [String: String]()
        headerFields["Authorization"] = "Token token=\"\(accessToken)\""
        req.allHTTPHeaderFields = headerFields
        return req
    }
    
    func serverError(forStatusCode statusCode: Int) -> APIError? {
        switch statusCode {
        case 500:
            return APIError.serverError
        case 502:
            return APIError.badGateway
        case 503:
            return APIError.serviceUnavailable
        case 504:
            return APIError.gatewayTimeout
        default:
            return nil
        }
    }
    
    @discardableResult
    func get<DecodableType: Decodable>(_ apiResource: Resource, params: [Param: Any]? = nil, options: RequestOptions? = nil, completion: @escaping (APIResult<DecodableType>) -> Void) -> URLSessionDataTask? {
        return request(method: .get, apiResource: apiResource, params: params, options: options, completion: completion)
    }
    
    @discardableResult
    func post<DecodableType: Decodable>(_ apiResource: Resource, params: [Param: Any]? = nil, options: RequestOptions? = nil, completion: @escaping (APIResult<DecodableType>) -> Void) -> URLSessionDataTask? {
        return request(method: .post, apiResource: apiResource, params: params, options: options, completion: completion)
    }
    
    @discardableResult
    func delete<DecodableType: Decodable>(_ apiResource: Resource, params: [Param: Any]? = nil, options: RequestOptions? = nil, completion: @escaping (APIResult<DecodableType>) -> Void) -> URLSessionDataTask? {
        return request(method: .delete, apiResource: apiResource, params: params, options: options, completion: completion)
    }
}

enum Param: String {
    case clientID =             "client_id"
    case redirectURI =          "redirect_uri"
    case responseType =         "response_type"
    case scope =                "scope"
    case accessToken =          "access_token"
    case searchQuery =          "q"
    case relationshipAction =   "action"
    case latitude =             "lat"
    case longitude =            "lng"
    case distance =             "distance"
    case commentText =          "text"
    case url =                  "url"
}

public struct RequestOptions {
    let minID: String?
    let maxID: String?
    let count: Int?
    
    public init(minID: String? = nil, maxID: String? = nil, count: Int? = nil) {
        self.minID = minID
        self.maxID = maxID
        self.count = count
    }
    
    public func toParameters() -> [String: Any] {
        var optionsParams: [String: Any] = [:]
        if let count = count {
            optionsParams["count"] = count
        }
        if let minID = minID {
            optionsParams["min_id"] = minID
        }
        if let maxID = maxID {
            optionsParams["max_id"] = maxID
        }
        return optionsParams
    }
}
