//
//  User.swift
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
import Decodable

public struct User {
    public let ID: String
    public let username: String
    public let fullName: String
    public let profilePictureURL: URL
    public let bio: String?
    public let websiteURL: URL?
    public let mediaCount: Int?
    public let followingCount: Int?
    public let followersCount: Int?
    
    public init(ID: String, username: String, fullName: String, profilePictureURL: URL, bio: String?,
                websiteURL: URL?, mediaCount: Int?, followingCount: Int?, followersCount: Int?) {
        self.ID = ID
        self.username = username
        self.fullName = fullName
        self.profilePictureURL = profilePictureURL
        self.bio = bio
        self.websiteURL = websiteURL
        self.mediaCount = mediaCount
        self.followingCount = followingCount
        self.followersCount = followersCount
    }
}

// MARK: Decodable

extension User: Decodable {
    public static func decode(_ json: Any) throws -> User {
        return try User(
            ID: json => "id",
            username: json => "username",
            fullName: json => "full_name",
            profilePictureURL: json => "profile_picture",
            bio: try? json => "bio",
            websiteURL: try? json => "website",
            mediaCount: try? json => "counts" => "media",
            followingCount: try? json => "counts" => "follows",
            followersCount: try? json => "counts" => "followed_by"
        )
    }
}
