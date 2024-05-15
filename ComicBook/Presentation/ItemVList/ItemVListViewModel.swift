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
        self.orderBy = getDefaultOrderBy(itemType: itemType)
    }
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20
    var hasNoMore = false
    var showBottomSheet = false
    var orderBy: OrderBy = OrderBy.modifiedDesc
    
    func resetItems() {
        hasNoMore = false
        items = []
        offset = 0
    }
        
    func getItems() async {
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
            
            let itemsResponse = try await fetchItems(prefix, id, offset, limit, orderBy.rawValue, searchText, false)
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
