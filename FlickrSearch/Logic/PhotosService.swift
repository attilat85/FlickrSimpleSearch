//
//  PhotosService.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation
import Alamofire

final class PhotosService {

    let networkClient: NetworkClient

    init() {
        networkClient = NetworkClient(config: APIConfiguration(baseUrl: API.backendURL), session: Alamofire.Session())
    }

    func getRecentPhotos(page: Int) async throws -> Photos {
        try await GetRecentApi(networkClient: networkClient).getRecentPhotos(page: page).photos
    }

    func searchPhotos(text: String, page: Int) async throws -> Photos {
        try await SearchPhotosApi(networkClient: networkClient).searchPhotos(text: text, page: page).photos
    }

}
