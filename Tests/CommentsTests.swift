//
//  CommentTests.swift
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

import Quick
import Nimble
import OHHTTPStubs
import Result
@testable import Gramophone

class CommentSpec: QuickSpec {
    override func spec() {
        let mediaID = "1482048616133874767_989545"
        
        describe("GET comments") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/\(mediaID)/comments") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("comments.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.comments(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.comments(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.comments(mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses into Comment objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.comments(mediaID: mediaID) {
                        completion($0) { comments in
                            expect(comments.items.count).to(equal(1))
                            expect(comments.items[0].ID).to(equal("17864190667127297"))
                            expect(comments.items[0].text).to(equal("#nyc #ny #manhattan #brooklyn #bridge #seeyourcity #nycprimeshot #alwaysnewyork #what_i_saw_in_nyc #ig_nycity #timeoutnewyork #made_in_nyc #newyorklike #nypix #nyloveyou #nyc_explorers #cityview #topnewyorkphoto #thebestdestinations #nycprimeshot #alwaysnewyork #instagramnyc #rsa_streetview #ig_nycity #thebest_capture #artofvisuals #theimaged #instagood #city_features #city_unit"))
                            expect(comments.items[0].creationDate).to(equal(Date(timeIntervalSince1970: 1490894006)))
                            
                            expect(comments.items[0].user.ID).to(equal("989545"))
                            expect(comments.items[0].user.username).to(equal("jverdi"))
                            expect(comments.items[0].user.fullName).to(equal("Jared Verdi"))
                            expect(comments.items[0].user.profilePictureURL).to(equal(
                                URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg")))
                        }
                    }
                }
            }
        }
        
        describe("POST comments") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/\(mediaID)/comments") && isMethodPOST()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("generic_success_response.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent, .comments]
            let commentString = "test comment #testing"
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.postComment(commentString, mediaID: mediaID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.postComment(commentString, mediaID: mediaID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.postComment(commentString, mediaID: mediaID) { completion($0) }
                }
            }
        }
        
        describe("DELETE comments") {
            let commentID = "17864190667127297"
            
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/\(mediaID)/comments/\(commentID)") && isMethodDELETE()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("generic_success_response.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.publicContent, .comments]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.deleteComment(mediaID: mediaID, commentID: commentID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.deleteComment(mediaID: mediaID, commentID: commentID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.deleteComment(mediaID: mediaID, commentID: commentID) { completion($0) }
                }
            }
        }
    }
}
