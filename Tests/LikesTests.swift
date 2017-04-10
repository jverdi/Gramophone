//
//  LikesTests.swift
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
import OHHTTPStubs
import Result
@testable import Gramophone

class LikesSpec: QuickSpec {
    override func spec() {
        let mediaID = "1482048616133874767_989545"

        let path = "/v1/media/\(mediaID)/likes"
        
        describe("GET likes") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("likes.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.likes(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.likes(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.likes(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses into Like objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.likes(mediaID: mediaID) {
                        completion($0) { likes in
                            expect(likes.items.count).to(equal(2))
                            
                            expect(likes.items[0].ID).to(equal("24515474"))
                            expect(likes.items[0].username).to(equal("richkern"))
                            expect(likes.items[0].fullName).to(equal("Rich Kern"))
                            expect(likes.items[0].profilePictureURL).to(equal(URL(string:
                                "https://scontent.cdninstagram.com/t51.2885-19/11849395_467018326835121_804084785_a.jpg"
                            )!))
                        }
                    }
                }
            }
        }
        
        describe("POST like") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodPOST()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("generic_success_response.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent, .likes]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.like(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.like(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.like(mediaID: mediaID) { completion($0) }
                }
            }
        }
        
        describe("DELETE like") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodDELETE()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("generic_success_response.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent, .likes]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.unlike(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.unlike(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.unlike(mediaID: mediaID) { completion($0) }
                }
            }
        }
    }
}
