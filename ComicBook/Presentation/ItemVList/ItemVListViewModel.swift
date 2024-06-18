//
//  ItemListViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation
import Combine

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
        
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedSearchText = text
            }
            .store(in: &cancellables)
    }
    
    @ObservationIgnored @Published var searchText = ""
    @ObservationIgnored @Published private(set) var debouncedSearchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var offset = 0
    var limit = 20
    var hasNoMore = false
    var showBottomSheet = false
    var orderBy: OrderBy = OrderBy.modifiedDesc
    private var fetchFromRemote: Bool = false
    
    func resetItems(fetchFromRemote: Bool = false) {
        self.fetchFromRemote = fetchFromRemote
        hasNoMore = false
        items = []
        offset = 0
    }
    
    @MainActor
    func getItems() async {
        if itemType == ItemType.favorite {
            items = await repository.retrieveFavoriteItems()
            hasNoMore = true
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
            let id = detailItem?.itemId ?? 0
            
            let itemsResponse = try await fetchItems(prefix, id, offset, limit, orderBy.rawValue, searchText, fetchFromRemote)
            self.fetchFromRemote = false
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
