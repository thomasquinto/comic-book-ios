//
//  ItemListHorizontalViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import Foundation

@Observable
class ItemHListViewModel {

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
    var offset = 0
    var limit = 20
    var hasNoMore = false
     
    func getItems() async {
        if itemType == ItemType.favorite {
            items = await repository.retrieveFavoriteItems()
            //hasNoMore = true
            return
        }
        
        hasNoMore = false
        if items.count == 0{
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
                
        do {
            let fetchItems = getFetchItems(itemType: itemType, repository: repository)
            let prefix = detailItem?.itemType.rawValue ?? ""
            let id = detailItem?.id ?? 0
            let orderBy = detailItem != nil ? getDefaultOrderBy(itemType: itemType) : OrderBy.modifiedDesc

            let itemsResponse = try await fetchItems(prefix, id, offset, limit, orderBy.rawValue, "", false)
            hasNoMore = itemsResponse.count < limit
            items += itemsResponse
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
