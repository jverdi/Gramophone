//
//  Error.swift
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
import Decodable

public enum APIError: Error {
    
    /**
     * Thrown when user initiates cancellation
     */
    case userCancelled
    
    /**
     *  Thrown when receiving an invalid HTTP response
     *
     *  @param response Optional URL response that has triggered the error
     */
    case invalidHTTPResponse(response: URLResponse?)
    
    /**
     *  Thrown when constructing an invalid URL
     *
     *  @param path The invalid URL string
     */
    case invalidURL(path: String)
    
    /**
     *  Thrown when required scopes were not included in the request
     *
     *  @param scopes The required scopes that were missing
     */
    case missingScopes(scopes: [Scope]?)
    
    /**
     *  Thrown when receiving unparseable JSON responses
     *
     *  @param data The data being parsed
     *  @param errorMessage The error which occured during parsing
     */
    case unparseableJSON(data: Data, errorMessage: String)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 400
     *  
     *  @param responseError The error information included in the response
     */
    case badRequest(responseError: ResponseError)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 401
     *  or when authentication is known to be required for a 
     *  request but the client has no access token
     *
     *  @param responseError The error information included in the response
     */
    case authenticationRequired(responseError: ResponseError?)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 403
     *
     *  @param responseError The error information included in the response
     */
    case forbidden(responseError: ResponseError)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 404
     *
     *  @param responseError The error information included in the response
     */
    case notFound(responseError: ResponseError)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 429
     *
     *  @param responseError The error information included in the response
     */
    case tooManyRequests(responseError: ResponseError)
    
    /**
     *  Thrown when encountering an HTTP Status Code of 500
     */
    case serverError
    
    /**
     *  Thrown when encountering an HTTP Status Code of 502
     */
    case badGateway
    
    /**
     *  Thrown when encountering an HTTP Status Code of 503
     */
    case serviceUnavailable
    
    /**
     *  Thrown when encountering an HTTP Status Code of 504
     */
    case gatewayTimeout
    
    /**
     *  Thrown when encountering any other unexpected HTTP Status Code
     *
     *  @param responseError The error information included in the response
     */
    case genericError(responseError: ResponseError)
    
    /**
     *  Thrown when encountering an unexpected error outside those specifically caught above
     *  At present the only case is errors falling in the NSURLErrorDomain for a URLSession data task
     *
     *  @param responseError The error information included in the response
     */
    case unknownError(responseError: Error)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            
        case .userCancelled:
            return "Cancelled"
            
        case .invalidHTTPResponse(let response):
            if let httpResponse = response as? HTTPURLResponse {
                return "Invalid HTTP Response: \(httpResponse.statusCode)"
            }
            return "Invalid Response"
            
        case .invalidURL(let path):
            return "Invalid URL: \(path)"
            
        case .missingScopes(let scopes):
            if let scopes = scopes {
                return "This API Request requires the following scopes that were not configured for your client: ['\(scopes.map{ $0.rawValue }.joined(separator: "', '"))']"
            }
            return "This API Request requires scopes that were not configured for your client"
            
        case .unparseableJSON(_, let errorMessage):
            return errorMessage
            
        case .badRequest(let responseError):
            return responseError.errorMessage()
            
        case .authenticationRequired(let responseError):
            if let responseError = responseError {
                return responseError.errorMessage()
            }
            else {
                return "Authentication Required: Please login and try again."
            }
            
        case .forbidden(let responseError):
            return responseError.errorMessage()
            
        case .notFound(let responseError):
            return responseError.errorMessage()
            
        case .tooManyRequests(let responseError):
            return responseError.errorMessage()
            
        case .serverError:
            return "Server Error: The server is unable to take requests at this time."
            
        case .badGateway:
            return "Bad Gateway: The server is unable to take requests at this time."
            
        case .serviceUnavailable:
            return "Service Unavailable: You may have hit Instagram's rate limit. Please try again later."
            
        case .gatewayTimeout:
            return "Gateway Timeout: The server is unable to take requests at this time."
            
        case .genericError(let responseError):
            return responseError.errorMessage()
        
        case .unknownError(let responseError):
            return responseError.localizedDescription
        }
    }
}
