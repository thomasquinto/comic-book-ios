//
//  ItemListViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

@Observable
class ItemListViewModel {

    let fetchItems: (String, Int, Int) async throws -> [Item]
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20
    var hasNoMore = false

    init(fetchItems: @escaping (String, Int, Int) async throws -> [Item]) {
        self.fetchItems = fetchItems
    }
        
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
            let itemsResponse = try await fetchItems(searchText, offset, limit)
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
