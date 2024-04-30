//
//  HomeView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI

struct HomeView: View {
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
                makeDetailView: makeComicDetailView(entity:)
            )
        } label: {
            Text(name)
        }
    }
    
    func makeComicDetailView(entity: Entity) -> AnyView {
        AnyView(EntityDetailView(entity: entity,
                                 fetchDetails1: ComicBookRepositoryImpl.shared.getComicCharacters,
                                 fetchDetails2: ComicBookRepositoryImpl.shared.getComicCreators,
                                 fetchDetails3: ComicBookRepositoryImpl.shared.getComicEvents,
                                 fetchDetails4: ComicBookRepositoryImpl.shared.getComicStories)
                )
    }
}
