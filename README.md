<p align="center">
	<a href="https://github.com/jverdi/Gramophone/"><img src="Assets/gramophone.png" alt="Gramophone" /></a><br />
</p>

[![Build Status](https://travis-ci.org/jverdi/Gramophone.svg?branch=master)](https://travis-ci.org/jverdi/Gramophone)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Gramophone.svg)](#cocoapods)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
[![GitHub release](https://img.shields.io/github/release/jverdi/Gramophone.svg)](https://github.com/jverdi/Gramophone/releases)
[![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)](#)
[![Pod License](https://img.shields.io/cocoapods/l/Gramophone.svg)](http://jaredverdi.mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@jverdi-blue.svg?style=flat)](http://twitter.com/jverdi)  

Gramophone is a framework for interacting with the Instagram REST API, written in Swift.  

It includes authentication via OAuth, and methods to make asynchronous network calls to all of Instagram's publicly available API endpoints. 

Responses are parsed into concrete model objects and errors. 

## Usage

Setup the client, supplying your Instagram [client id and redirect URI](https://www.instagram.com/developer/clients/manage/), as well as any desired [scopes](https://www.instagram.com/developer/authorization/):

```swift
import Gramophone

let configuration = ClientConfiguration(
    clientID: "{YOUR_INSTAGRAM_CLIENT_ID}", 
    redirectURI: "{YOUR_INSTAGRAM_REDIRECT_URI}", 
    scopes: [.basic, .publicContent, .comments]
)
let gramophone = Gramophone(configuration: configuration)
```

Authenticate using OAuth (with an in-app `WKWebView` controller):

```swift
gramophone.client.authenticate(from: presentingViewController) { result in
    switch result {
    case .success(let response):
        print("Authenticated")

    case .failure(let error):
        print("Failed to authenticate: \(error.localizedDescription)")
    }
}
```

Request data using one of the API wrapper methods:

```swift
gramophone.client.myRecentMedia(options: nil) { mediaResult in
    switch mediaResult {
    case .success(let response):
        let mediaItems = response.data.items
        for media in mediaItems {
	    if let images = media.images, let rendition = images[.thumbnail] {
	        print("Media [ID: \(media.ID), url: \(rendition.url)]")
	    }
        }
    case .failure(let error):
        print("Failed to load media: \(error.localizedDescription)")
    }
}
```

See the [Resources](http://github.com/jverdi/Gramophone/tree/master/Source/Resources) directory for the full listing of available API methods:  

| API Wrapper | Methods | Instagram Docs |
| ------------- | ------------- | ------------- |
| [Auth](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/Auth.swift) | <ul><li>```authenticate(from:) => String```</li></ul> | [Docs](https://www.instagram.com/developer/authentication/) |
| [Comments](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/CommentsAPI.swift) | <ul><li>```comments(mediaID:) => Array<Comment>```</li><li>```postComment(_:mediaID:) => NoData```</li><li>```deleteComment(mediaID:commentID:) => NoData```</li></ul> | [Docs](https://www.instagram.com/developer/endpoints/comments) |
| [Likes](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/LikesAPI.swift) | <ul><li>```likes(mediaID:) => <Array<Like>>```</li><li>```like(mediaID:) => NoData```</li><li>```unlike(mediaID:) => NoData```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/likes) |
| [Locations](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/LocationsAPI.swift) | <ul><li>```location(ID:) => Location```</li><li>```locationRecentMedia(ID:options:) => Array<Media>```</li><li>```locations(latitude:longitude:distanceInMeters:) => Array<Location>```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/locations) |
| [Media](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/MediaAPI.swift) | <ul><li>```media(withID:) => Media```</li><li>```media(withShortcode:) => Media```</li><li>```media(latitude:longitude:distanceInMeters:) => Array<Media>```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/media) |
| [OEmbed](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/OEmbed.swift) | <ul><li>```oembed(url:) => EmbedMedia```</li></ul>  | [Docs](https://www.instagram.com/developer/embedding/#oembed) |
| [Relationships](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/RelationshipsAPI.swift) | <ul><li>```myFollows() => Array<User>```</li><li>```myFollowers() => Array<User>```</li><li>```myRequests() => Array<User>```</li><li>```relationship(withUserID:) => IncomingRelationship```</li><li>```followUser(withID:) => OutgoingRelationship```</li><li>```unfollowUser(withID:) => OutgoingRelationship```</li><li>```approveUser(withID:) => IncomingRelationship```</li><li>```ignoreUser(withID:) => IncomingRelationship```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/relationships) |
| [Tags](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/TagsAPI.swift) | <ul><li>```tag(name:) => Tag```</li><li>```tagRecentMedia(name:options:) => Array<Media>```</li><li>```tags(query:options:) => Array<Tag>```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/tags) |
| [Users](http://github.com/jverdi/Gramophone/blob/master/Source/Resources/UsersAPI.swift) | <ul><li>```me() => User```</li><li>```user(withID:) => User```</li><li>```myRecentMedia(options:) => Array<Media>```</li><li>```userRecentMedia(withID:options:) => Array<Media>```</li><li>```myLikedMedia(options:) => Array<Media>```</li><li>```users(query:options:) => Array<User>```</li></ul>  | [Docs](https://www.instagram.com/developer/endpoints/users) |


## Installation

### CocoaPods

To integrate Gramophone using [CocoaPods](http://cocoapods.org), add it to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '{YOUR_TARGET}' do
    pod 'Gramophone', '~> 1.0'
end
```

Then, run:

```bash
$ pod install
```

### Carthage

To integrate Gramophone using [Carthage](https://github.com/Carthage/Carthage), add it to your `Cartfile`:

```ogdl
github "jverdi/Gramophone" ~> 1.0
```

Then, run:

```bash
$ carthage update --platform iOS
```

and drag the built `Gramophone.framework`, `Decodable.framework`, and `Result.framework` into your Xcode project's Embedded Binaries from `Carthage/Build/iOS`.


## Dependencies

Gramophone makes use of the [Decodable](https://github.com/Anviking/Decodable) and [Result](https://github.com/antitypical/Result) libraries.


## License

Gramophone is released under the MIT license. See [LICENSE](https://github.com/jverdi/Gramophone/blob/master/LICENSE) for details.

Icon created by Gan Khoon Lay from the Noun Project
