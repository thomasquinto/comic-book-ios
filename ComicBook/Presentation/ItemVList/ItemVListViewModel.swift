//
//  ItemListViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

@Observable
class ItemVListViewModel {

    let itemType: ItemType
    let detailItem: Item?
    let repository: ComicBookRepository

    init(itemType: ItemType,
         detailItem: Item?,
         repository: ComicBookRepository
    ) {
        self.itemType = itemType
        self.detailItem = detailItem
        self.repository = repository
    }
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20
    var hasNoMore = false
        
    func getItems(reset: Bool = false) async {
        hasNoMore = false
        if reset || items.count == 0{
            items = []
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
        
        do {
            let fetchItems = getFetchItems(itemType: itemType, repository: repository)
            let prefix = detailItem?.itemType.rawValue ?? ""
            let id = detailItem?.id ?? 0
            let orderBy = getDefaultOrderBy(itemType: itemType)
            
            let itemsResponse = try await fetchItems(prefix, id, offset, limit, orderBy.rawValue, searchText, false)
            hasNoMore = itemsResponse.count < limit
            if reset {
                items = itemsResponse
            } else {
                items += itemsResponse
            }
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
