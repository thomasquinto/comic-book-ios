//
//  HomeViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

@Observable
class ComicListViewModel {
    private let repo: ComicBookRepository

    var comics: [Comic] = []
    var isLoading: Bool = false
    var errorMessage: String = ""
    var isShowingAlert = false
    
    init(repo: ComicBookRepository) {
        self.repo = repo
    }
    
    func getComics() async {
        isLoading = true
        
        do {
            comics = try await repo.getComics(offset: 0, limit: 20)
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
