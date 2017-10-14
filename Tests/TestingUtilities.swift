//
//  TestingUtilities.swift
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
import Quick
import Nimble
import Result
import protocol Decodable.Decodable
import Decodable
@testable import Gramophone

let GramophoneTestsAccessToken = "4869495376.ee2868a.8ed8666e997948bebbcb82445bc0f66d" //"FAKE_ACCESS_TOKEN"
let GramophoneTestsHost = "api.instagram.com"
let GramophoneTestsHeaders = ["Content-Type": "application/json"]

let enableStubbing = true

struct TestingUtilities {
    static func unauthenticatedGramophone(withScopes scopes: [Scope] = []) -> Gramophone {
        let configuration = ClientConfiguration(clientID: "test_id", redirectURI: "http://gramophone.eesel.com", scopes: scopes)
        let session = URLSession(configuration: .default)
        let client = Client(configuration: configuration, session: session)
        return Gramophone(client: client)
    }
    
    static func authenticatedGramophone(withScopes scopes: [Scope] = []) -> Gramophone {
        let configuration = ClientConfiguration(clientID: "test_id", redirectURI: "http://gramophone.eesel.com", scopes: scopes)
        let session = URLSession(configuration: .default)
        let client = Client(configuration: configuration, session: session)
        client.accessToken = GramophoneTestsAccessToken
        
        return Gramophone(client: client)
    }
    
    static func testScopes<T: Decodable>(scopes: [Scope], request: @escaping (Gramophone, @escaping ((APIResult<T>) -> ())) -> ()) {
        let gramophone = TestingUtilities.authenticatedGramophone(withScopes: [])
        waitUntil { done in
            request(gramophone) { result in
                switch result {
                case Result.success(_): fail("request should require the scopes: \(scopes.map{ $0.rawValue }.joined(separator: Scope.separator))")
                case Result.failure(let error):
                    switch error {
                    case .missingScopes(let scopes):
                        expect(scopes).to(equal(scopes));
                        break
                    default: fail("expected missing scopes error")
                    }
                }
                done()
            }
        }
    }
    
    static func testAuthentication<T: Decodable>(scopes: [Scope] = [], request: @escaping (Gramophone, @escaping ((APIResult<T>) -> ())) -> ()) {
        let gramophone = TestingUtilities.unauthenticatedGramophone(withScopes: scopes)
        waitUntil { done in
            request(gramophone) { result in
                switch result {
                case Result.success(_): fail("request should require authentication")
                case Result.failure(let error):
                    switch error {
                    case .authenticationRequired(_): break
                    default: fail("expected authentication error")
                    }
                }
                done()
            }
        }
    }
    
    static func testSuccessfulRequest<T: Decodable>(httpCode: UInt, scopes: [Scope] = [], requireMeta: Bool = true,
                                      request: @escaping (Gramophone, @escaping ((APIResult<T>) -> ())) -> ()) {
        let gramophone = TestingUtilities.authenticatedGramophone(withScopes: scopes)
        waitUntil { done in
            request(gramophone) { result in
                if case let Result.success(response) = result {
                    if requireMeta {
                        guard let metadata = response.meta else { fail("meta was missing"); return }
                        guard let code = metadata.httpCode else { fail("code was missing"); return }
                        expect(code).to(equal(httpCode))
                    }
                }
                else {
                    fail("response parsing was unsuccessful")
                }
                done()
            }
        }
    }
    
    static func testSuccessfulRequestWithDataConfirmation<T: Decodable>(httpCode: UInt, scopes: [Scope] = [], requireMeta: Bool = true,
                                                          request: @escaping (Gramophone, @escaping ((APIResult<T>, (T) -> ()) -> ())) -> ()) {
        
        let gramophone = TestingUtilities.authenticatedGramophone(withScopes: scopes)
        waitUntil { done in
            request(gramophone) { result, confirmData in
                if case let Result.success(response) = result {
                    if requireMeta {
                        guard let metadata = response.meta else { fail("meta was missing"); return }
                        guard let code = metadata.httpCode else { fail("code was missing"); return }
                        expect(code).to(equal(httpCode))
                    }
                    confirmData(response.data)
                }
                else {
                    fail("response parsing was unsuccessful")
                }
                done()
            }
        }
    }
}
