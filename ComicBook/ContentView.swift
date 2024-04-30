//
//  ContentView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                EntityLinkView(name: "Comics", fetchEntities: ComicBookRepositoryImpl.shared.getComics)
                EntityLinkView(name: "Characters", fetchEntities: ComicBookRepositoryImpl.shared.getCharacters)
                EntityLinkView(name: "Series", fetchEntities: ComicBookRepositoryImpl.shared.getSeries)
                EntityLinkView(name: "Creators", fetchEntities: ComicBookRepositoryImpl.shared.getCreators)
                EntityLinkView(name: "Events", fetchEntities: ComicBookRepositoryImpl.shared.getEvents)
                EntityLinkView(name: "Stories", fetchEntities: ComicBookRepositoryImpl.shared.getStories)
            }
            .navigationTitle("Marvel Comics")
        }
    }
    
    func EntityLinkView(name: String, fetchEntities: @escaping (String, Int, Int) async throws -> [Entity]) -> some View {
        NavigationLink {
            EntityListView(
                entityName: name,
                fetchEntities: fetchEntities,
                makeDetailView: getEntityDetailView(entity:)
            )
        } label: {
            Text(name)
        }
    }
    
    func getEntityDetailView(entity: Entity) -> AnyView {
        AnyView(EntityDetailView(entity: entity))
    }
}

#Preview {
    ContentView()
}
