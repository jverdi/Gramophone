//
//  MediaTests.swift
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
@testable import Gramophone

class MediaSpec: QuickSpec {
    override func spec() {
        let mediaID = "1482048616133874767_989545"
        let mediaShortcode = "BSRS104hNRP"
        
        let scopes: [Scope] = [.publicContent]

        describe("GET media by id") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/\(mediaID)") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("medium.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }

            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withID: mediaID) { completion($0) }
                }
            }

            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withID: mediaID) { completion($0) }
                }
            }

            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withID: mediaID) { completion($0) }
                }
            }

            it("parses into Location objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withID: mediaID) {
                        completion($0) { media in
                            expect(media.ID).to(equal(mediaID))
                            expect(media.user.ID).to(equal("989545"))
                            expect(media.user.fullName).to(equal("Jared Verdi"))
                            expect(media.user.profilePictureURL).to(equal(
                                URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg"))
                            )
                            expect(media.user.username).to(equal("jverdi"))
                            if let caption = media.caption {
                                expect(caption.ID).to(equal("17864935459119823"))
                                expect(caption.text).to(equal("Bridge Sunsets\n.\n.\n.\n.\n.\n.\n#sunrise #chasingsunrise #skylovers #longexposure_shots #longexpo #nakedplanet #earthmagazine #ourplanetdaily #thebest_capture #natgeowild #natgeohub #awesomeearth #master_shots #skylove #instasky #yourshottphotographer #sunrise_and_sunsets #sunrise_sunsets_aroundworld #cloudlovers #cloudsofinstagram #instasunrise #sunrisesunset #cloudstagram #best_skyshots #twilightscapes #artofvisuals #theimaged #instagood #instagoodmyphoto #peoplescreatives"))
                                expect(caption.creationDate).to(equal(Date(timeIntervalSince1970: 1490893984)))
                                expect(caption.creator.ID).to(equal("989545"))
                                expect(caption.creator.fullName).to(equal("Jared Verdi"))
                                expect(caption.creator.profilePictureURL).to(equal(
                                    URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg")
                                ))
                                expect(caption.creator.username).to(equal("jverdi"))
                            }
                            expect(media.userHasLiked).to(equal(false))
                            expect(media.likesCount).to(equal(136))
                            expect(Set(media.tags)).to(equal(Set(["peoplescreatives", "instasky", "chasingsunrise", "instagoodmyphoto", "awesomeearth", "cloudlovers", "best_skyshots", "yourshottphotographer", "sunrise", "cloudsofinstagram", "theimaged", "nakedplanet", "earthmagazine", "natgeohub", "master_shots", "longexpo", "skylove", "ourplanetdaily", "instagood", "natgeowild", "skylovers", "artofvisuals", "thebest_capture", "twilightscapes", "longexposure_shots", "sunrise_and_sunsets", "instasunrise", "sunrisesunset", "sunrise_sunsets_aroundworld", "cloudstagram"])))
                            expect(media.filterName).to(equal("Ashby"))
                            expect(media.commentCount).to(equal(10))
                            expect(media.type).to(equal(Media.MediaType.image))
                            expect(media.url).to(equal(URL(string: "https://www.instagram.com/p/BSRS104hNRP/")))
                            expect(media.location).to(beNil())
//                            expect(media.attribution).to(beNil())
                            expect(media.usersInPhoto).to(beEmpty())
                        }
                    }
                }
            }
        }

        describe("GET media by shortcode") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/shortcode/\(mediaShortcode)") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("medium.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }

            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withShortcode: mediaShortcode) { completion($0) }
                }
            }

            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withShortcode: mediaShortcode) { completion($0) }
                }
            }

            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withShortcode: mediaShortcode) { completion($0) }
                }
            }

            it("parses into Media objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(withShortcode: mediaShortcode) {
                        completion($0) { media in
                            expect(media.ID).to(equal(mediaID))
                            expect(media.user.ID).to(equal("989545"))
                            expect(media.user.fullName).to(equal("Jared Verdi"))
                            expect(media.user.profilePictureURL).to(equal(
                                URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg"))
                            )
                            expect(media.user.username).to(equal("jverdi"))
                            if let caption = media.caption {
                                expect(caption.ID).to(equal("17864935459119823"))
                                expect(caption.text).to(equal("Bridge Sunsets\n.\n.\n.\n.\n.\n.\n#sunrise #chasingsunrise #skylovers #longexposure_shots #longexpo #nakedplanet #earthmagazine #ourplanetdaily #thebest_capture #natgeowild #natgeohub #awesomeearth #master_shots #skylove #instasky #yourshottphotographer #sunrise_and_sunsets #sunrise_sunsets_aroundworld #cloudlovers #cloudsofinstagram #instasunrise #sunrisesunset #cloudstagram #best_skyshots #twilightscapes #artofvisuals #theimaged #instagood #instagoodmyphoto #peoplescreatives"))
                                expect(caption.creationDate).to(equal(Date(timeIntervalSince1970: 1490893984)))
                                expect(caption.creator.ID).to(equal("989545"))
                                expect(caption.creator.fullName).to(equal("Jared Verdi"))
                                expect(caption.creator.profilePictureURL).to(equal(
                                    URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg")
                                ))
                                expect(caption.creator.username).to(equal("jverdi"))
                            }
                            expect(media.userHasLiked).to(equal(false))
                            expect(media.likesCount).to(equal(136))
                            expect(Set(media.tags)).to(equal(Set(["peoplescreatives", "instasky", "chasingsunrise", "instagoodmyphoto", "awesomeearth", "cloudlovers", "best_skyshots", "yourshottphotographer", "sunrise", "cloudsofinstagram", "theimaged", "nakedplanet", "earthmagazine", "natgeohub", "master_shots", "longexpo", "skylove", "ourplanetdaily", "instagood", "natgeowild", "skylovers", "artofvisuals", "thebest_capture", "twilightscapes", "longexposure_shots", "sunrise_and_sunsets", "instasunrise", "sunrisesunset", "sunrise_sunsets_aroundworld", "cloudstagram"])))
                            expect(media.filterName).to(equal("Ashby"))
                            expect(media.commentCount).to(equal(10))
                            expect(media.type).to(equal(Media.MediaType.image))
                            expect(media.url).to(equal(URL(string: "https://www.instagram.com/p/BSRS104hNRP/")))
                            expect(media.location).to(beNil())
                            //                            expect(media.attribution).to(beNil())
                            expect(media.usersInPhoto).to(beEmpty())
                        }
                    }
                }
            }
        }

        describe("GET location by geo coordinate") {
            if enableStubbing {
                stub(condition: isHost(GramophoneTestsHost) && isPath("/v1/media/search") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("media.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }

            let latitude = 37.782
            let longitude = -122.387
            let distance = 10.0

            it("requires the correct scopes") {
                TestingUtilities.testScopes(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(latitude: latitude, longitude: longitude, distanceInMeters: distance) { completion($0) }
                }
            }

            it("requires authentication") {
                TestingUtilities.testAuthentication(scopes: scopes) { gramophone, completion in
                    gramophone.client.media(latitude: latitude, longitude: longitude, distanceInMeters: distance) { completion($0) }
                }
            }

            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(latitude: latitude, longitude: longitude, distanceInMeters: distance) { completion($0) }
                }
            }

            it("parses into Media objects") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, scopes: scopes) { gramophone, completion in
                    gramophone.client.media(latitude: latitude, longitude: longitude, distanceInMeters: distance) {
                        completion($0) { media in
                            expect(media.items.count).to(equal(3))
                            
                            let media = media.items[0]
                            
                            expect(media.ID).to(equal("1482048616133874767_989545"))
                            expect(media.user.ID).to(equal("989545"))
                            expect(media.user.fullName).to(equal("Jared Verdi"))
                            expect(media.user.profilePictureURL).to(equal(
                                URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg"))
                            )
                            expect(media.user.username).to(equal("jverdi"))
                            expect(media.images).toNot(beNil())
                            if let images = media.images {
                                expect(images[Media.ImageSize.thumbnail]).toNot(beNil())
                                expect(images[Media.ImageSize.lowRes]).toNot(beNil())
                                expect(images[Media.ImageSize.standard]).toNot(beNil())
                                
                                if let thumbnail = images[Media.ImageSize.thumbnail] {
                                    expect(thumbnail.width).to(equal(150))
                                    expect(thumbnail.height).to(equal(150))
                                    expect(thumbnail.url).to(equal(URL(string:
                                        "https://scontent.cdninstagram.com/t51.2885-15/s150x150/e35/c108.0.863.863/17662429_420883991615204_3921714365731962880_n.jpg"
                                        )!))
                                }
                                if let lowRes = images[Media.ImageSize.lowRes] {
                                    expect(lowRes.width).to(equal(320))
                                    expect(lowRes.height).to(equal(255))
                                    expect(lowRes.url).to(equal(URL(string:
                                        "https://scontent.cdninstagram.com/t51.2885-15/s320x320/e35/17662429_420883991615204_3921714365731962880_n.jpg"
                                        )!))
                                }
                                if let standard = images[Media.ImageSize.standard] {
                                    expect(standard.width).to(equal(640))
                                    expect(standard.height).to(equal(511))
                                    expect(standard.url).to(equal(URL(string:
                                        "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/17662429_420883991615204_3921714365731962880_n.jpg"
                                        )!))
                                }
                            }
                            expect(media.videos).to(beNil())
                            expect(media.creationDate).to(equal(Date(timeIntervalSince1970: 1490893984)))
                            
                            if let caption = media.caption {
                                expect(caption.ID).to(equal("17864935459119823"))
                                expect(caption.text).to(equal("Bridge Sunsets\n.\n.\n.\n.\n.\n.\n#sunrise #chasingsunrise #skylovers #longexposure_shots #longexpo #nakedplanet #earthmagazine #ourplanetdaily #thebest_capture #natgeowild #natgeohub #awesomeearth #master_shots #skylove #instasky #yourshottphotographer #sunrise_and_sunsets #sunrise_sunsets_aroundworld #cloudlovers #cloudsofinstagram #instasunrise #sunrisesunset #cloudstagram #best_skyshots #twilightscapes #artofvisuals #theimaged #instagood #instagoodmyphoto #peoplescreatives"))
                                expect(caption.creationDate).to(equal(Date(timeIntervalSince1970: 1490893984)))
                                expect(caption.creator.ID).to(equal("989545"))
                                expect(caption.creator.fullName).to(equal("Jared Verdi"))
                                expect(caption.creator.profilePictureURL).to(equal(
                                    URL(string: "https://scontent.cdninstagram.com/t51.2885-19/11249876_446198148894593_1426023307_a.jpg")
                                ))
                                expect(caption.creator.username).to(equal("jverdi"))
                            }
                            expect(media.userHasLiked).to(equal(false))
                            expect(media.likesCount).to(equal(136))
                            expect(Set(media.tags)).to(equal(Set(["peoplescreatives", "instasky", "chasingsunrise", "instagoodmyphoto", "awesomeearth", "cloudlovers", "best_skyshots", "yourshottphotographer", "sunrise", "cloudsofinstagram", "theimaged", "nakedplanet", "earthmagazine", "natgeohub", "master_shots", "longexpo", "skylove", "ourplanetdaily", "instagood", "natgeowild", "skylovers", "artofvisuals", "thebest_capture", "twilightscapes", "longexposure_shots", "sunrise_and_sunsets", "instasunrise", "sunrisesunset", "sunrise_sunsets_aroundworld", "cloudstagram"])))
                            expect(media.filterName).to(equal("Ashby"))
                            expect(media.commentCount).to(equal(10))
                            expect(media.type).to(equal(Media.MediaType.image))
                            expect(media.url).to(equal(URL(string: "https://www.instagram.com/p/BSRS104hNRP/")))
                            expect(media.location).to(beNil())
//                            expect(media.attribution).to(beNil())
                            expect(media.usersInPhoto).to(beEmpty())
                        }
                    }
                }
            }
        }
    }
}
