//
//  EntityListHorizontalViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import Foundation

@Observable
class EntityListHorizontalViewModel {

    let id: Int
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Entity]

    init(id: Int, 
         fetchDetails: @escaping (Int, Int, Int, String?) async throws -> [Entity]) {
        self.id = id
        self.fetchDetails = fetchDetails
    }
    
    var entities: [Entity] = []
    var isLoading = false
    var errorMessage = ""
    var isShowingAlert = false
    var offset = 0
    var limit = 20
    var hasNoMore = false
     
    func getEntities(reset: Bool = false) async {
        hasNoMore = false
        if reset || entities.count == 0{
            entities = []
            offset = 0
        } else {
            offset += limit
        }
        isLoading = true
        
        do {
            let entitiesResponse = try await fetchDetails(id, offset, limit, nil)
            hasNoMore = entitiesResponse.count < limit
            if reset {
                entities = entitiesResponse
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
