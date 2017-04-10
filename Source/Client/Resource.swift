//
//  Resource.swift
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

protocol Resource {
    func uri() -> String
}

extension Client {
    func resource(_ resource: Resource, options: RequestOptions?, parameters: [String: Any]? = nil) -> URL? {
        if var components = URLComponents(string: "\(configuration.apiScheme)://\(configuration.apiHost)\(resource.uri())") {
            if let queryItems = queryItems(options: options, parameters: parameters), queryItems.count > 0 {
                components.queryItems = queryItems
            }
            if let url = components.url {
                return url
            }
        }
        
        return nil
    }
    
    func queryItems(options: RequestOptions?, parameters: [String: Any]? = nil) -> [URLQueryItem]? {
        if let parameters = combineParameters(options: options, parameters: parameters) {
            let queryItems: [URLQueryItem] = parameters.map { key, value in
                var value = value
                
                if let array = value as? NSArray {
                    value = array.componentsJoined(by: ",")
                }
                return URLQueryItem(name: key, value: (value as AnyObject).description)
            }
            return queryItems
        }
        return nil
    }
    
    fileprivate func combineParameters(options: RequestOptions?, parameters: [String: Any]? = nil) -> [String: Any]? {
        var optionsParams = options != nil ? options!.toParameters() : [String: Any]()
        if let parameters = parameters {
            parameters.forEach{ optionsParams.updateValue($1, forKey: $0) }
        }
        return optionsParams
    }
}
