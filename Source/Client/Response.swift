//
//  Response.swift
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
import Result

public typealias APIResult<T: Decodable> = Result<APIResponse<T>, APIError>

// data type representing responses that dont expect model objects to be returned as data
public struct NoData: Decodable {
    public static func decode(_ json: Any) throws -> NoData { return NoData() }
}

extension Client {
    func handleJSON<T: Decodable>(_ data: Data, _ response: URLResponse?, _ completion: (APIResult<T>) -> Void) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let _ = try? json => "data" as AnyObject {
                completion(Result.success(try APIResponse<T>.decode(json)))
            }
            else if let meta = try? json => "meta" as AnyObject, let metadata = try? APIMetadata.decode(meta) {
                completion(Result.failure(errorForAPIMetadata(metadata, response: response)))
            }
            else {
                // oembed endpoint response is not wrapped by data
                completion(Result.success(try APIResponse<T>.rawDecode(json)))
            }
        }
        catch let error as DecodingError {
            completion(.failure(APIError.unparseableJSON(data: data, errorMessage: "\(error)")))
        }
        catch _ {
            completion(.failure(APIError.unparseableJSON(data: data, errorMessage: "")))
        }
    }
    
    func errorForAPIMetadata(_ metadata: APIMetadata, response: URLResponse?) -> APIError {
        let responseError = metadata.error
        let code: UInt?
        if let httpResponse = response as? HTTPURLResponse {
            code = UInt(httpResponse.statusCode)
        }
        else {
            code = metadata.httpCode
        }
        return errorForHTTPStatusCode(code, responseError: responseError, metadata: metadata)
    }

    func errorForHTTPStatusCode(_ httpStatusCode: UInt?, responseError: ResponseError?, metadata: APIMetadata) -> APIError {
        let httpStatusCode = httpStatusCode ?? UInt.max
        let responseError = responseError ?? ResponseError(message: "Unknown Error", type: "Unknown Error")
        
        switch httpStatusCode {
        case 400:
            if let type = metadata.error?.type {
                if type == "OAuthPermissionsException" {
                    return APIError.missingScopes(scopes: nil)
                }
                else if type == "APINotAllowedError" {
                    return APIError.forbidden(responseError: responseError)
                }
                else if type == "APINotFoundError" {
                    return APIError.notFound(responseError: responseError)
                }
                else if type == "APIInvalidParametersError" {
                    return APIError.badRequest(responseError: responseError)
                }
            }
            return APIError.badRequest(responseError: responseError)
        case 401:
            return APIError.authenticationRequired(responseError: responseError)
        case 403:
            return APIError.forbidden(responseError: responseError)
        case 404:
            return APIError.notFound(responseError: responseError)
        case 429:
            return APIError.tooManyRequests(responseError: responseError)
        default:
            return APIError.genericError(responseError: responseError)
        }
    }
}
