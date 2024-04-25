//
//  ComicListViewModel.swift
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
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20
    var isEmpty = false

    init(repo: ComicBookRepository) {
        self.repo = repo
    }
        
    func getComics(reset: Bool = false) async {
        isEmpty = false
        if reset || comics.count == 0{
            comics = []
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
        
        do {
            let comicsResponse = try await repo.getComics(titleStartsWith: searchText, offset: offset, limit: limit)
            if reset {
                comics = comicsResponse
                isEmpty = comics.isEmpty
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
