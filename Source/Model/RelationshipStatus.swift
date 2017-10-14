//
//  RelationshipStatus.swift
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

public enum IncomingRelationshipStatus {
    case followedBy
    case requestedBy
    case blockedByYou
    case none
    case unknown
}

public enum OutgoingRelationshipStatus {
    case follows
    case requested
    case none
    case unknown
}

public struct IncomingRelationship {
    let status: IncomingRelationshipStatus
    
    public init(status: IncomingRelationshipStatus) {
        self.status = status
    }
}

public struct OutgoingRelationship {
    let status: OutgoingRelationshipStatus
    let targetUserIsPrivate: Bool
    
    public init(status: OutgoingRelationshipStatus, targetUserIsPrivate: Bool) {
        self.status = status
        self.targetUserIsPrivate = targetUserIsPrivate
    }
}

// MARK: Decodable

extension OutgoingRelationship: Decodable {
    public static func decode(_ json: Any) throws -> OutgoingRelationship {
        return OutgoingRelationship(
            status: try OutgoingRelationshipStatus.decode(json => "outgoing_status"),
            targetUserIsPrivate: try json => "target_user_is_private"
        )
    }
}

extension IncomingRelationship: Decodable {
    public static func decode(_ json: Any) throws -> IncomingRelationship {
        return IncomingRelationship(
            status: try IncomingRelationshipStatus.decode(json => "incoming_status")
        )
    }
}

extension IncomingRelationshipStatus: Decodable {
    public static func decode(_ json: Any) throws -> IncomingRelationshipStatus {
        switch json {
        case let str as String where str == "followed_by": return .followedBy
        case let str as String where str == "requested_by": return .requestedBy
        case let str as String where str == "blocked_by_you": return .blockedByYou
        case let str as String where str == "none": return .none
        default: return .unknown
        }
    }
}

extension OutgoingRelationshipStatus: Decodable {
    public static func decode(_ json: Any) throws -> OutgoingRelationshipStatus {
        switch json {
        case let str as String where str == "follows": return .follows
        case let str as String where str == "requested": return .requested
        case let str as String where str == "none": return .none
        default: return .unknown
        }
    }
}
