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

    private var disposeBag = DisposeBag()

    var searchText: String?

    func getRecentPhotos() {
        getRecentPhotos(page: 0)
    }

    private func getRecentPhotos(page: Int) {
        if page == 0 {
            photos = [] //reset content and show loading indicator
        }
        if photos.isEmpty {
            _state.onNext(.loading)
        }
        Task {
            do {
                photosPage = try await service.getRecentPhotos(page: page)
                if page == 0 {
                    photos = photosPage?.photo ?? []
                } else {
                    photos += photosPage?.photo ?? [] // when is load more append the photos
                }
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

    func search(page: Int = 0) {
        if page == 0 {
            photos = [] //reset content and show loading indicator
        }

        guard let text = searchText else {
            photos = []
            _state.onNext(.content)
            return
        }
        if photos.isEmpty {
            _state.onNext(.loading)
        }
        Task {
            do {
                photosPage = try await service.searchPhotos(text: text, page: page)
                if page == 0 {
                    photos = photosPage?.photo ?? []
                } else {
                    photos += photosPage?.photo ?? []
                }
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

    func loadMore() {
        let page = (photosPage?.page ?? 0) + 1
        
        guard page < (photosPage?.pages ?? 0) else { return }

        if !(searchText?.isEmpty ?? true) {
            search(page: page)
        } else {
            getRecentPhotos(page: page)
        }
    }
}
