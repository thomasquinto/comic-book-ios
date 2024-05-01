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
            ScrollView {
                EntityLinkView(name: "Comics", fetchDetails: ComicBookRepositoryImpl.shared.getComics, fetchEntities: ComicBookRepositoryImpl.shared.getComics)
                EntityLinkView(name: "Characters", fetchDetails: ComicBookRepositoryImpl.shared.getCharacters, fetchEntities: ComicBookRepositoryImpl.shared.getCharacters)
                EntityLinkView(name: "Series", fetchDetails: ComicBookRepositoryImpl.shared.getSeries, fetchEntities: ComicBookRepositoryImpl.shared.getSeries)
                EntityLinkView(name: "Creators", fetchDetails: ComicBookRepositoryImpl.shared.getCreators, fetchEntities: ComicBookRepositoryImpl.shared.getCreators)
                EntityLinkView(name: "Events", fetchDetails: ComicBookRepositoryImpl.shared.getEvents, fetchEntities: ComicBookRepositoryImpl.shared.getEvents)
                EntityLinkView(name: "Stories", fetchDetails: ComicBookRepositoryImpl.shared.getStories, fetchEntities: ComicBookRepositoryImpl.shared.getStories)
            }
            .scrollIndicators(.hidden)
            .scenePadding()
            .navigationTitle("Marvel Comics")
        }
    }
}



struct EntityLinkView : View {
    let name: String
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Entity]
    let fetchEntities: (String, Int, Int) async throws -> [Entity]

    var body: some View {
        NavigationLink {
            EntityListView(
                entityName: name,
                fetchEntities: fetchEntities,
                makeDetailView: makeDetailView
            )
        } label: {
            EntityListHorizontalView(id: 0, name: name, fetchDetails: fetchDetails, makeDetailView: makeDetailView)
        }
        .buttonStyle(PlainButtonStyle())
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
