//
//  EmbedMedia.swift
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
import protocol Decodable.Decodable
import Decodable

public struct EmbedMedia {
    public let ID: String
    public let userID: Int
    public let userName: String
    public let userURL: URL
    public let width: Int
    public let height: Int?
    public let html: String
    public let providerName: String
    public let providerURL: URL
    public let title: String?
    public let type: String
    public let thumbnailURL: URL
    public let thumbnailWidth: Int
    public let thumbnailHeight: Int
    public let version: String
    
    
    public init(ID: String, userID: Int, userName: String, userURL: URL, width: Int,
                height: Int?, html: String, providerName: String, providerURL: URL, title: String?,
                type: String, thumbnailURL: URL, thumbnailWidth: Int, thumbnailHeight: Int, version: String) {
        self.ID = ID
        self.userID = userID
        self.userName = userName
        self.userURL = userURL
        self.width = width
        self.height = height
        self.html = html
        self.providerName = providerName
        self.providerURL = providerURL
        self.title = title
        self.type = type
        self.thumbnailURL = thumbnailURL
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.version = version
    }
}

// MARK: Equatable

extension EmbedMedia: Equatable {
    public static func ==(lhs: EmbedMedia, rhs: EmbedMedia) -> Bool {
        return lhs.ID == rhs.ID
    }
}

// MARK: Decodable

extension EmbedMedia: Decodable {
    public static func decode(_ json: Any) throws -> EmbedMedia {
        return try EmbedMedia(
            ID: json => "media_id",
            userID: json => "author_id",
            userName: json => "author_name",
            userURL: json => "author_url",
            width: json => "width",
            height: try? json => "height",
            html: json => "html",
            providerName: json => "provider_name",
            providerURL: json => "provider_url",
            title: try? json => "title",
            type: json => "type",
            thumbnailURL: json => "thumbnail_url",
            thumbnailWidth: json => "thumbnail_width",
            thumbnailHeight: json => "thumbnail_height",
            version: json => "version"
        )
    }
}
