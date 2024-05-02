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
                ItemLinkView(name: "Comics", fetchDetails: ComicBookRepositoryImpl.shared.getComics, fetchItems: ComicBookRepositoryImpl.shared.getComics)
                ItemLinkView(name: "Characters", fetchDetails: ComicBookRepositoryImpl.shared.getCharacters, fetchItems: ComicBookRepositoryImpl.shared.getCharacters)
                ItemLinkView(name: "Series", fetchDetails: ComicBookRepositoryImpl.shared.getSeries, fetchItems: ComicBookRepositoryImpl.shared.getSeries)
                ItemLinkView(name: "Creators", fetchDetails: ComicBookRepositoryImpl.shared.getCreators, fetchItems: ComicBookRepositoryImpl.shared.getCreators)
                ItemLinkView(name: "Events", fetchDetails: ComicBookRepositoryImpl.shared.getEvents, fetchItems: ComicBookRepositoryImpl.shared.getEvents)
                ItemLinkView(name: "Stories", fetchDetails: ComicBookRepositoryImpl.shared.getStories, fetchItems: ComicBookRepositoryImpl.shared.getStories)
            }
            .scrollIndicators(.hidden)
            .scenePadding()
            .navigationTitle("Marvel Comics")
        }
    }
}



struct ItemLinkView : View {
    let name: String
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Item]
    let fetchItems: (String, Int, Int) async throws -> [Item]

    var body: some View {
        NavigationLink {
            ItemListView(
                itemName: name,
                fetchItems: fetchItems,
                makeDetailView: makeDetailView
            )
        } label: {
            ItemListHorizontalView(id: 0, name: name, fetchDetails: fetchDetails, makeDetailView: makeDetailView)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

func makeDetailView(item: Item, detailName: String) -> AnyView {
    switch detailName {
    case "Characters":
        return makeCharacterDetailView(item: item)
    case "Comics":
        return makeComicDetailView(item: item)
    case "Creators":
        return makeCreatorDetailView(item: item)
    case "Events":
        return makeEventDetailView(item: item)
    case "Series":
        return makeSeriesDetailView(item: item)
    case "Stories":
        return makeStoryDetailView(item: item)
    default:
        return makeComicDetailView(item: item)
    }
}

func makeCharacterDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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

func makeComicDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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

func makeCreatorDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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

func makeEventDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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

func makeSeriesDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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

func makeStoryDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
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
