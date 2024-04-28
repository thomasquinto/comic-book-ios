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
