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
                NavigationLink {
                    EntityListView(
                        entityName: "Comics",
                        fetchEntities: ComicBookRepositoryImpl.shared.getComics,
                        makeDetailView: getEntityDetailView(entity:)
                    )
                } label: {
                    Text("Comics")
                }
                NavigationLink {
                    EntityListView(
                        entityName: "Characters",
                        fetchEntities: ComicBookRepositoryImpl.shared.getCharacters,
                        makeDetailView: getEntityDetailView(entity:)
                    )
                } label: {
                    Text("Characters")
                }
                NavigationLink {
                    EntityListView(
                        entityName: "Events",
                        fetchEntities: ComicBookRepositoryImpl.shared.getEvents,
                        makeDetailView: getEntityDetailView(entity:)
                    )
                } label: {
                    Text("Events")
                }
                NavigationLink {
                    EntityListView(
                        entityName: "Stories",
                        fetchEntities: ComicBookRepositoryImpl.shared.getStories,
                        makeDetailView: getEntityDetailView(entity:)
                    )
                } label: {
                    Text("Stories")
                }
                NavigationLink {
                    EntityListView(
                        entityName: "Creators",
                        fetchEntities: ComicBookRepositoryImpl.shared.getCreators,
                        makeDetailView: getEntityDetailView(entity:)
                    )
                } label: {
                    Text("Creators")
                }
            }
        }
    }
    
    func getEntityDetailView(entity: Entity) -> AnyView {
        AnyView(EntityDetailView(entity: entity))
    }
}

#Preview {
    ContentView()
}
