//
//  EmbedMediaTests.swift
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

class EmbedMediaSpec: QuickSpec {
    override func spec() {
        let url = URL(string: "https://www.instagram.com/p/BSRS104hNRP")!

        describe("GET oembed") {
            if enableStubbing {
                stub(condition: isHost("api.instagram.com") && isPath("/oembed") && isMethodGET()) { request in
                    return OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("oembed.json", type(of: self))!,
                        statusCode: 200,
                        headers: GramophoneTestsHeaders
                    )
                }
            }

            it("requires authentication") {
                TestingUtilities.testAuthentication() { gramophone, completion in
                    gramophone.client.oembed(url: url) { completion($0) }
                }
            }

            it("parses http successful response") {
                TestingUtilities.testSuccessfulRequest(httpCode: 200, requireMeta: false) { gramophone, completion in
                    gramophone.client.oembed(url: url) { completion($0) }
                }
            }

            it("parses into an OEmbed object") {
                TestingUtilities.testSuccessfulRequestWithDataConfirmation(httpCode: 200, requireMeta: false) { gramophone, completion in
                    gramophone.client.oembed(url: url) {
                        completion($0) { oembed in
                            expect(oembed.ID).to(equal("1482048616133874767_989545"))
                            expect(oembed.userID).to(equal(989545))
                            expect(oembed.userName).to(equal("jverdi"))
                            expect(oembed.userURL).to(equal(
                                URL(string: "https://www.instagram.com/jverdi"))
                            )
                            expect(oembed.width).to(equal(658))
                            expect(oembed.height).to(beNil())
                            expect(oembed.html).to(equal("<blockquote class=\"instagram-media\" data-instgrm-captioned data-instgrm-version=\"7\" style=\" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:658px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);\"><div style=\"padding:8px;\"> <div style=\" background:#F8F8F8; line-height:0; margin-top:40px; padding:39.9537037037037% 0; text-align:center; width:100%;\"> <div style=\" background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAMUExURczMzPf399fX1+bm5mzY9AMAAADiSURBVDjLvZXbEsMgCES5/P8/t9FuRVCRmU73JWlzosgSIIZURCjo/ad+EQJJB4Hv8BFt+IDpQoCx1wjOSBFhh2XssxEIYn3ulI/6MNReE07UIWJEv8UEOWDS88LY97kqyTliJKKtuYBbruAyVh5wOHiXmpi5we58Ek028czwyuQdLKPG1Bkb4NnM+VeAnfHqn1k4+GPT6uGQcvu2h2OVuIf/gWUFyy8OWEpdyZSa3aVCqpVoVvzZZ2VTnn2wU8qzVjDDetO90GSy9mVLqtgYSy231MxrY6I2gGqjrTY0L8fxCxfCBbhWrsYYAAAAAElFTkSuQmCC); display:block; height:44px; margin:0 auto -44px; position:relative; top:-22px; width:44px;\"></div></div> <p style=\" margin:8px 0 0 0; padding:0 4px;\"> <a href=\"https://www.instagram.com/p/BSRS104hNRP/\" style=\" color:#000; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none; word-wrap:break-word;\" target=\"_blank\">Bridge Sunsets . . . . . . #sunrise #chasingsunrise #skylovers #longexposure_shots #longexpo #nakedplanet #earthmagazine #ourplanetdaily #thebest_capture #natgeowild #natgeohub #awesomeearth #master_shots #skylove #instasky #yourshottphotographer #sunrise_and_sunsets #sunrise_sunsets_aroundworld #cloudlovers #cloudsofinstagram #instasunrise #sunrisesunset #cloudstagram #best_skyshots #twilightscapes #artofvisuals #theimaged #instagood #instagoodmyphoto #peoplescreatives</a></p> <p style=\" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;\">A post shared by Jared Verdi (@jverdi) on <time style=\" font-family:Arial,sans-serif; font-size:14px; line-height:17px;\" datetime=\"2017-03-30T17:13:04+00:00\">Mar 30, 2017 at 10:13am PDT</time></p></div></blockquote>\n<script async defer src=\"//platform.instagram.com/en_US/embeds.js\"></script>"))
                            expect(oembed.providerName).to(equal("Instagram"))
                            expect(oembed.providerURL).to(equal(
                                URL(string: "https://www.instagram.com"))
                            )
                            expect(oembed.title).to(equal("Bridge Sunsets\n.\n.\n.\n.\n.\n.\n#sunrise #chasingsunrise #skylovers #longexposure_shots #longexpo #nakedplanet #earthmagazine #ourplanetdaily #thebest_capture #natgeowild #natgeohub #awesomeearth #master_shots #skylove #instasky #yourshottphotographer #sunrise_and_sunsets #sunrise_sunsets_aroundworld #cloudlovers #cloudsofinstagram #instasunrise #sunrisesunset #cloudstagram #best_skyshots #twilightscapes #artofvisuals #theimaged #instagood #instagoodmyphoto #peoplescreatives"))
                            expect(oembed.type).to(equal("rich"))
                            expect(oembed.thumbnailURL).to(equal(
                                URL(string: "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/17662429_420883991615204_3921714365731962880_n.jpg"))
                            )
                            expect(oembed.thumbnailWidth).to(equal(640))
                            expect(oembed.thumbnailHeight).to(equal(511))
                            expect(oembed.version).to(equal("1.0"))
                        }
                    }
                }
            }
        }
    }
}
