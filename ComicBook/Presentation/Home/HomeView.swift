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
                makeDetailView: makeDetailView
            )
        } label: {
            Text(name)
        }
    }

}

func makeDetailView(entity: Entity, detailName: String) -> AnyView {
    switch detailName {
    case "Characters":
        return makeCharacterDetailView(entity: entity)
    case "Comics":
        return makeComicDetailView(entity: entity)
    case "Creators":
        return makeCreatorDetailView(entity: entity)
    case "Events":
        return makeEventDetailView(entity: entity)
    case "Series":
        return makeSeriesDetailView(entity: entity)
    case "Stories":
        return makeStoryDetailView(entity: entity)
    default:
        return makeComicDetailView(entity: entity)
    }
}

func makeCharacterDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Comics",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getCharacterComics,
                             detailName2: "Series",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getCharacterSeries,
                             detailName3: "Events",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getCharacterEvents,
                             detailName4: "Stories",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getCharacterStories,
                             detailName5: nil,
                             fetchDetails5: nil)
            )
}

func makeComicDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Characters",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getComicCharacters,
                             detailName2: "Creators",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getComicCreators,
                             detailName3: "Events",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getComicEvents,
                             detailName4: "Stories",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getComicStories,
                             detailName5: nil,
                             fetchDetails5: nil)
            )
}

func makeCreatorDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Comics",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getCreatorComics,
                             detailName2: "Series",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getCreatorSeries,
                             detailName3: "Events",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getCreatorEvents,
                             detailName4: "Stories",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getCreatorStories,
                             detailName5: nil,
                             fetchDetails5: nil)
            )
}

func makeEventDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Comics",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getEventComics,
                             detailName2: "Characters",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getEventCharacters,
                             detailName3: "Creators",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getEventCreators,
                             detailName4: "Series",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getEventSeries,
                             detailName5: "Stories",
                             fetchDetails5: ComicBookRepositoryImpl.shared.getEventStories)
            )
}

func makeSeriesDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Comics",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getSeriesComics,
                             detailName2: "Characters",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getSeriesCharacters,
                             detailName3: "Creators",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getSeriesCreators,
                             detailName4: "Events",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getSeriesEvents,
                             detailName5: "Stories",
                             fetchDetails5: ComicBookRepositoryImpl.shared.getSeriesStories)
            )
}

func makeStoryDetailView(entity: Entity) -> AnyView {
    AnyView(EntityDetailView(entity: entity,
                             makeDetailView: makeDetailView,
                             detailName1: "Comics",
                             fetchDetails1: ComicBookRepositoryImpl.shared.getStoryComics,
                             detailName2: "Characters",
                             fetchDetails2: ComicBookRepositoryImpl.shared.getStoryCharacters,
                             detailName3: "Creators",
                             fetchDetails3: ComicBookRepositoryImpl.shared.getStoryCreators,
                             detailName4: "Events",
                             fetchDetails4: ComicBookRepositoryImpl.shared.getStoryEvents,
                             detailName5: "Series",
                             fetchDetails5: ComicBookRepositoryImpl.shared.getStorySeries)
            )
}
