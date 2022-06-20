//
//  API.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation

public struct EmptyRequest: Encodable { }

enum API {
    static let backendURL = "https://www.flickr.com/services/rest/"
    static let photoWebPage = "https://www.flickr.com/photos/"
    static let photoUrl = "https://live.staticflickr.com/"
    static let apiKey = "935102b3d5001ce8e0cd8704122d8e70"

    enum Path {
        static let getRecent    = "flickr.photos.getrecent"
        static let search       = "flickr.photos.search"

    }

    enum Param {
        static let apiKey           = "api_key"
        static let format           = "format"
        static let nojsoncallback   = "nojsoncallback"
        static let text             = "text"
        static let perPage          = "per_page"
        static let method           = "method"
    }

    enum Value {
        static let format           = "json"
        static let nojsoncallback   = 1
    }
}
