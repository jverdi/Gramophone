//
//  GramophoneTests.swift
//  GramophoneTests
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

class GramophoneSpec: QuickSpec {
    override func spec() {
        let configuration = ClientConfiguration(clientID: "test_id", redirectURI: "http://gramophone.eesel.com")
        let session = URLSession(configuration: .default)
        let client = Client(configuration: configuration, session: session)
        let gramophone = Gramophone(client: client)
        
        describe("a gramophone") {
            it("exists") {
                expect(gramophone).toNot(beNil())
                expect(gramophone).to(beAKindOf(Gramophone.self))
            }
            it("has a client") {
                expect(gramophone.client).toNot(beNil())
                expect(gramophone.client).to(beAKindOf(Client.self))
            }
            it("has a configured client") {
                expect(gramophone.client.configuration).toNot(beNil())
            }
        }
    }
    
    
    
}
