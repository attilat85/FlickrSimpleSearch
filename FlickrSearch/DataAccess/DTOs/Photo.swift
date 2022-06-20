//
//  Photo.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let owner: String
    let title: String
    let server: String
    let secret: String
    let ispublic: Int
    var url: String {
        "\(API.photoUrl)\(server)/\(id)_\(secret).jpg"
    }
    var webPageUrl: String {
        "\(API.photoWebPage)\(owner)/\(id)"
    }
}


