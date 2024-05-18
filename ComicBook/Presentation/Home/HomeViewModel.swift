//
//  HomeViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/17/24.
//

import Foundation

@Observable
class HomeViewModel {
    
    let repository: ComicBookRepository

    init(repository: ComicBookRepository) {
        self.repository = repository
    }
    
    func refresh() async {
        await repository.deleteCache()
    }
}
