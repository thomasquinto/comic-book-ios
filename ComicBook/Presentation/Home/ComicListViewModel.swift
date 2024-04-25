//
//  HomeViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation
import Combine

@Observable
class ComicListViewModel {
    private let repo: ComicBookRepository

    var comics: [Comic] = []
    var isLoading: Bool = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20

    init(repo: ComicBookRepository) {
        self.repo = repo
    }
        
    func getComics(reset: Bool = false) async {
        if reset {
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
        
        do {
            let comicsResponse = try await repo.getComics(titleStartsWith: searchText, offset: offset, limit: limit)
            if reset {
                comics = comicsResponse
            } else {
                comics += comicsResponse
            }
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
