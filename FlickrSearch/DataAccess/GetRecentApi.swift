//
//  GetRecentApi.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation

// swiftlint:disable nesting
class GetRecentApi {

    private let networkClient: NetworkClient
    
    struct Request: Encodable {
        var method = API.Path.getRecent
        var api_key = API.apiKey
        var format = API.Value.format
        var nojsoncallback = API.Value.nojsoncallback
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getRecentPhotos() async throws -> PhotosContainer {
        try await networkClient.execute(data: Request())
    }

}
