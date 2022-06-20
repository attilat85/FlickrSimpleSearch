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

    func getRecentPhotos() async throws -> Photos {
        try await GetRecentApi(networkClient: networkClient).getRecentPhotos().photos
    }

}
