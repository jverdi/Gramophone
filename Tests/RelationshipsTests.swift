//
//  RelationshipStatusTests.swift
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

class RelationshipsSpec: QuickSpec {
    override func spec() {
        describe("GET follows") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/users/self/follows") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationships_follows.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }

            let scopes: [Scope] = [.followerList]

            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollows{ completion($0) }
                }
            }

            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollows{ completion($0) }
                }
            }

            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollows{ completion($0) }
                }
            }

            it("parses into User objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollows{
                        completion($0) { users in
                            
                        }
                    }
                }
            }
        }

        describe("GET followers") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/users/self/followed-by") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationships_followers.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.followerList]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollowers{ completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollowers{ completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollowers{ completion($0) }
                }
            }
            
            it("parses into User objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myFollowers{
                        completion($0) { users in
                        
                        }
                    }
                }
            }
        }
        
        describe("GET requests") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/users/self/requested-by") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationships_requests.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.followerList]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.myRequests{ completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.myRequests{ completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myRequests{ completion($0) }
                }
            }
            
            it("parses into User objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.myRequests{
                        completion($0) { users in
                            
                        }
                    }
                }
            }
        }
        
        let relationshipUserID = "989545"
        let path = "/v1/users/\(relationshipUserID)/relationship"
        let scopes: [Scope] = [.relationships]
        
        describe("GET relationship by id") {
            
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationship_both.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            let scopes: [Scope] = [.followerList]
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.relationship(withUserID: relationshipUserID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.relationship(withUserID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.relationship(withUserID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses into an IncomingRelationship object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.relationship(withUserID: relationshipUserID) {
                        completion($0) { incomingRelationship in
                            
                        }
                    }
                }
            }
        }
        
        describe("POST follow user by id") {
            if enableStubbing {
                let body = "action=follow".data(using: .utf8)!
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodPOST() && hasBody(body)) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationship_both.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.followUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.followUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.followUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses into an OutgoingRelationship object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.followUser(withID: relationshipUserID) {
                        completion($0) { outgoingRelationship in
                            expect(outgoingRelationship.status).to(equal(OutgoingRelationshipStatus.follows))
                        }
                    }
                }
            }
        }
        
        describe("POST unfollow user by id") {
            if enableStubbing {
                let body = "action=unfollow".data(using: .utf8)!
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodPOST() && hasBody(body)) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationship_outgoing.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.unfollowUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.unfollowUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.unfollowUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses into an OutgoingRelationship object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.unfollowUser(withID: relationshipUserID) {
                        completion($0) { outgoingRelationship in
                            expect(outgoingRelationship.status).to(equal(OutgoingRelationshipStatus.none))
                        }
                    }
                }
            }
        }
        
        describe("POST approve user by id") {
            if enableStubbing {
                let body = "action=approve".data(using: .utf8)!
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodPOST() && hasBody(body)) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationship_incoming.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.approveUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.approveUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.approveUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses into an OutgoingRelationship object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.approveUser(withID: relationshipUserID) {
                        completion($0) { incomingRelationship in
                            expect(incomingRelationship.status).to(equal(IncomingRelationshipStatus.followedBy))
                        }
                    }
                }
            }
        }
        
        describe("POST ignore user by id") {
            if enableStubbing {
                let body = "action=ignore".data(using: .utf8)!
                stub(condition: isHost(GramophoneTestsHost) && isPath(path) && isMethodPOST() && hasBody(body)) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("relationship_incoming.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }
            
            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.ignoreUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.ignoreUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.ignoreUser(withID: relationshipUserID) { completion($0) }
                }
            }
            
            it("parses into an IncomingRelationship object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.ignoreUser(withID: relationshipUserID) {
                        completion($0) { incomingRelationship in
                            expect(incomingRelationship.status).to(equal(IncomingRelationshipStatus.followedBy))
                        }
                    }
                }
            }
        }
    }
}
