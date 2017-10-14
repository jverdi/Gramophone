//
//  Media.swift
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

public struct Media {
    public enum MediaType {
        case image
        case video
        case unknown
    }
    public enum ImageSize {
        case thumbnail
        case lowRes
        case standard
        case unknown
        
        public func key() -> String {
            switch self {
            case .thumbnail: return "thumbnail"
            case .lowRes: return "low_resolution"
            case .standard: return "standard_resolution"
            case .unknown: assertionFailure("Media.ImageSize.unknown has no associated key"); return ""
            }
        }
        
    }
    public enum VideoSize {
        case lowRes
        case standard
        case unknown
        
        public func key() -> String {
            switch self {
            case .lowRes: return "low_resolution"
            case .standard: return "standard_resolution"
            case .unknown: assertionFailure("Media.VideoSize.unknown has no associated key"); return ""
            }
        }
    }
    public final class MediaRendition {
        public let width: Int
        public let height: Int
        public let url: URL
        
        public init(width: Int, height: Int, url: URL) {
            self.width = width
            self.height = height
            self.url = url
        }
    }
    public final class UserTag {
        public let position: CGPoint
        public let user: User
        
        public init(position: CGPoint, user: User) {
            self.position = position
            self.user = user
        }
    }
    
    public let ID: String
    public let user: User
    public let type: MediaType
    public let images: [Media.ImageSize: MediaRendition]?
    public let videos: [Media.VideoSize: MediaRendition]?
    public let caption: Caption?
    public let userHasLiked: Bool
    public let creationDate: Date
    public let url: URL
    public let likesCount: Int
    public let commentCount: Int
    public let usersInPhoto: [UserTag]
    public let filterName: String
    public let location: Location?
    public let tags: [String]
    
    public init(ID: String, user: User, type: MediaType, images: [Media.ImageSize: MediaRendition]?, videos: [Media.VideoSize: MediaRendition]?,
                caption: Caption?, userHasLiked: Bool, creationDate: Date, url: URL, likesCount: Int, commentCount: Int,
                usersInPhoto: [Media.UserTag], filterName: String, location: Location?, tags: [String]) {
        self.ID = ID
        self.user = user
        self.type = type
        self.images = images
        self.videos = videos
        self.caption = caption
        self.userHasLiked = userHasLiked
        self.creationDate = creationDate
        self.url = url
        self.likesCount = likesCount
        self.commentCount = commentCount
        self.usersInPhoto = usersInPhoto
        self.filterName = filterName
        self.location = location
        self.tags = tags
    }
}

// MARK: Equatable

extension Media: Equatable {
    public static func ==(lhs: Media, rhs: Media) -> Bool {
        return lhs.ID == rhs.ID
    }
}

// MARK: Decodable

extension Media: Decodable {
    public static func decode(_ json: Any) throws -> Media {
        var images: [ImageSize: MediaRendition]? = nil
        let imageSizes: [String: Any]? = try? json => "images" as! [String : Any]
        if let imageSizes = imageSizes {
            images = [:]
            for (imageSizeKey, imageSizeValue) in imageSizes {
                if let key = try? ImageSize.decode(imageSizeKey), let value = try? MediaRendition.decode(imageSizeValue) {
                    images![key] = value
                }
            }
        }
        
        var videos: [VideoSize: MediaRendition]? = nil
        let videoSizes: [String: Any]? = try? json => "videos" as! [String : Any]
        if let videoSizes = videoSizes {
            videos = [:]
            for (videoSizeKey, videoSizeValue) in videoSizes {
                if let key = try? VideoSize.decode(videoSizeKey), let value = try? MediaRendition.decode(videoSizeValue) {
                    videos![key] = value
                }
            }
        }
        
        return try Media(
            ID: json => "id",
            user: json => "user",
            type: json => "type",
            images: images,
            videos: videos,
            caption: try? json => "caption",
            userHasLiked: json => "user_has_liked",
            creationDate: json => "created_time",
            url: json => "link",
            likesCount: json => "likes" => "count",
            commentCount: json => "comments" => "count",
            usersInPhoto: json => "users_in_photo",
            filterName: json => "filter",
            location: try? json => "location",
            tags: json => "tags"
        )
    }
}
extension Media.MediaType: Decodable {
    public static func decode(_ json: Any) throws -> Media.MediaType {
        switch json {
        case let str as String where str == "image": return .image
        case let str as String where str == "video": return .video
        default: return .unknown
        }
    }
}
extension Media.ImageSize: Decodable {
    public static func decode(_ json: Any) throws -> Media.ImageSize {
        switch json {
        case let str as String where str == "thumbnail": return .thumbnail
        case let str as String where str == "low_resolution": return .lowRes
        case let str as String where str == "standard_resolution": return .standard
        default: return .unknown
        }
    }
}
extension Media.VideoSize: Decodable {
    public static func decode(_ json: Any) throws -> Media.VideoSize {
        switch json {
        case let str as String where str == "low_resolution": return .lowRes
        case let str as String where str == "standard_resolution": return .standard
        default: return .unknown
        }
    }
}
extension Media.MediaRendition: Decodable {
    public static func decode(_ json: Any) throws -> Media.MediaRendition {
        return try Media.MediaRendition(
            width: json => "width",
            height: json => "height",
            url: json => "url"
        )
    }
}
extension Media.UserTag: Decodable {
    public static func decode(_ json: Any) throws -> Media.UserTag {
        return try Media.UserTag(
            position: json => "position",
            user: json => "user"
        )
    }
}
extension CGPoint: Decodable {
    public static func decode(_ json: Any) throws -> CGPoint {
        return try CGPoint(
            x: json => "x" as Double,
            y: json => "y" as Double
        )
    }
}
