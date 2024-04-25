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

    init(repo: ComicBookRepository) {
        self.repo = repo
    }
        
    func getComics() async {
        isLoading = true
        
        do {
            comics = try await repo.getComics(titleStartsWith: searchText, offset: 0, limit: 20)
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
