//
//  ItemListHorizontalViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import Foundation

@Observable
class ItemListHorizontalViewModel {

    let id: Int
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Item]

    init(id: Int, 
         fetchDetails: @escaping (Int, Int, Int, String?) async throws -> [Item]) {
        self.id = id
        self.fetchDetails = fetchDetails
    }
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
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
            let itemsResponse = try await fetchDetails(id, offset, limit, nil)
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
