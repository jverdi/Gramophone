//
//  Locations.swift
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
    fileprivate enum Locations: Resource {
        case withID(String)
        case recentMedia(withID: String)
        case search
        
        func uri() -> String {
            switch self {
            case .withID(let locationID):           return "/v1/locations/\(locationID)"
            case .recentMedia(let locationID):      return "/v1/locations/\(locationID)/media/recent"
            case .search:                           return "/v1/locations/search"
            }
        }
    }
}

extension Client {
    @discardableResult
    public func location(ID: String, completion: @escaping (APIResult<Location>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Locations.withID(ID), completion: completion)
    }
    
    @discardableResult
    public func locationRecentMedia(ID: String, options: RequestOptions?, completion: @escaping (APIResult<Array<Media>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        return get(API.Locations.recentMedia(withID: ID), completion: completion)
    }
    
    @discardableResult
    public func locations(latitude: Double, longitude: Double, distanceInMeters: Double?, completion: @escaping (APIResult<Array<Location>>) -> Void) -> URLSessionDataTask? {
        if let error = validateScopes([Scope.publicContent]) { completion(Result.failure(error)); return nil }
        
        var params: [Param: Any] = [
            Param.latitude: latitude,
            Param.longitude: longitude
        ]
        if let dist = distanceInMeters {
            params[Param.distance] = dist
        }
        
        return get(API.Locations.search, params: params, completion: completion)
    }
}
