//
//  EntityListViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

@Observable
class EntityListViewModel {

    let fetchEntities: (String, Int, Int) async throws -> [Entity]
    
    var entities: [Entity] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var searchText = ""
    var offset = 0
    var limit = 20
    var isEmpty = false

    init(fetchEntities: @escaping (String, Int, Int) async throws -> [Entity]) {
        self.fetchEntities = fetchEntities
    }
        
    func getEntities(reset: Bool = false) async {
        isEmpty = false
        if reset || entities.count == 0{
            entities = []
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
        
        do {
            let entitiesResponse = try await fetchEntities(searchText, offset, limit)
            if reset {
                entities = entitiesResponse
                isEmpty = entities.isEmpty
            } else {
                entities += entitiesResponse
            }
            isLoading = false
        } catch {
            isLoading = false
            isShowingAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
