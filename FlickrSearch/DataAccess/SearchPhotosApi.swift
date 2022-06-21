//
//  SSearchPhotosApi.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation

// swiftlint:disable nesting
class SearchPhotosApi {

    private let networkClient: NetworkClient

    struct Request: Encodable {
        var method = API.Path.search
        var api_key = API.apiKey
        var format = API.Value.format
        var nojsoncallback = API.Value.nojsoncallback
        let text: String
        let page: Int
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func searchPhotos(text: String, page: Int) async throws -> PhotosContainer {
        try await networkClient.execute(data: Request(text: text, page: page))
    }

}
