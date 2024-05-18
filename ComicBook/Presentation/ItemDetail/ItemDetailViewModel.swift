//
//  ItemDetailViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/17/24.
//

import Foundation

@Observable
class ItemDetailViewModel {
    
    let item: Item
    let repository: ComicBookRepository
    var isFavorite: Bool = false
    
    init(item: Item, repository: ComicBookRepository) {
        self.item = item
        self.repository = repository
    }
    
    func initFavorite() async {
        isFavorite = await repository.retrieveFavoriteItems().contains(item)
    }
    
    func toggleFavorite() async {
        isFavorite = !isFavorite
        await repository.updateFavorite(item: item, isFavorite: isFavorite)
    }
    
}
