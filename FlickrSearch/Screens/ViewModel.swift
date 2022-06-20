//
//  ViewModel.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import Foundation
import RxSwift

enum ViewState {
    case loading, content
    case error(Error)
}

final class ViewModel {

    private let service = PhotosService()

    var state: Observable<ViewState> { _state.asObservable() }
    private var _state = BehaviorSubject<ViewState>(value: .loading)

    var photos: [Photo] = []
    private var photosPage: Photos?

    func getRecentPhotos() {
        _state.onNext(.loading)
        Task {
            do {
                photosPage = try await service.getRecentPhotos()
                photos = photosPage?.photo.filter({ $0.ispublic == 1 }) ?? []
                DispatchQueue.main.async { [weak self] in
                    self?._state.onNext(.content)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?._state.onNext(.error(error))
                }
            }
        }
    }
}
