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
                ItemLinkView(itemType: .comic, fetchDetails: ComicBookRepositoryImpl.shared.getComics, fetchItems: ComicBookRepositoryImpl.shared.getComics)
                ItemLinkView(itemType: .character, fetchDetails: ComicBookRepositoryImpl.shared.getCharacters, fetchItems: ComicBookRepositoryImpl.shared.getCharacters)
                ItemLinkView(itemType: .series, fetchDetails: ComicBookRepositoryImpl.shared.getSeries, fetchItems: ComicBookRepositoryImpl.shared.getSeries)
                ItemLinkView(itemType: .creator, fetchDetails: ComicBookRepositoryImpl.shared.getCreators, fetchItems: ComicBookRepositoryImpl.shared.getCreators)
                ItemLinkView(itemType: .event, fetchDetails: ComicBookRepositoryImpl.shared.getEvents, fetchItems: ComicBookRepositoryImpl.shared.getEvents)
                ItemLinkView(itemType: .story, fetchDetails: ComicBookRepositoryImpl.shared.getStories, fetchItems: ComicBookRepositoryImpl.shared.getStories)
            }
            .scrollIndicators(.hidden)
            .scenePadding()
            .navigationTitle("Marvel Comics")
        }
    }
}



struct ItemLinkView : View {
    let itemType: ItemType
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Item]
    let fetchItems: (String, Int, Int) async throws -> [Item]

    var body: some View {
        NavigationLink {
            ItemListView(
                itemName: itemType,
                fetchItems: fetchItems,
                makeDetailView: makeDetailView
            )
        } label: {
            ItemListHorizontalView(id: 0, name: itemType.rawValue.capitalized, fetchDetails: fetchDetails, makeDetailView: makeDetailView)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

func makeDetailView(item: Item, detailType: ItemType) -> AnyView {
    switch detailType {
    case .character:
        return makeCharacterDetailView(item: item)
    case .comic:
        return makeComicDetailView(item: item)
    case .creator:
        return makeCreatorDetailView(item: item)
    case .event:
        return makeEventDetailView(item: item)
    case .series:
        return makeSeriesDetailView(item: item)
    case .story:
        return makeStoryDetailView(item: item)
    }
}

func makeCharacterDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.comic.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getCharacterComics,
                           detailName2: ItemType.series.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getCharacterSeries,
                           detailName3: ItemType.event.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getCharacterEvents,
                           detailName4: ItemType.story.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getCharacterStories,
                           detailName5: nil,
                           fetchDetails5: nil)
            )
}

func makeComicDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.character.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getComicCharacters,
                           detailName2: ItemType.creator.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getComicCreators,
                           detailName3: ItemType.event.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getComicEvents,
                           detailName4: ItemType.story.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getComicStories,
                           detailName5: nil,
                           fetchDetails5: nil)
            )
}

func makeCreatorDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.comic.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getCreatorComics,
                           detailName2: ItemType.series.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getCreatorSeries,
                           detailName3: ItemType.event.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getCreatorEvents,
                           detailName4: ItemType.story.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getCreatorStories,
                           detailName5: nil,
                           fetchDetails5: nil)
            )
}

func makeEventDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.comic.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getEventComics,
                           detailName2: ItemType.character.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getEventCharacters,
                           detailName3: ItemType.creator.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getEventCreators,
                           detailName4: ItemType.series.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getEventSeries,
                           detailName5: ItemType.story.rawValue.capitalized,
                           fetchDetails5: ComicBookRepositoryImpl.shared.getEventStories)
            )
}

func makeSeriesDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.comic.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getSeriesComics,
                           detailName2: ItemType.character.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getSeriesCharacters,
                           detailName3: ItemType.creator.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getSeriesCreators,
                           detailName4: ItemType.event.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getSeriesEvents,
                           detailName5: ItemType.story.rawValue.capitalized,
                           fetchDetails5: ComicBookRepositoryImpl.shared.getSeriesStories)
            )
}

func makeStoryDetailView(item: Item) -> AnyView {
    AnyView(ItemDetailView(item: item,
                           makeDetailView: makeDetailView,
                           detailName1: ItemType.comic.rawValue.capitalized,
                           fetchDetails1: ComicBookRepositoryImpl.shared.getStoryComics,
                           detailName2: ItemType.character.rawValue.capitalized,
                           fetchDetails2: ComicBookRepositoryImpl.shared.getStoryCharacters,
                           detailName3: ItemType.creator.rawValue.capitalized,
                           fetchDetails3: ComicBookRepositoryImpl.shared.getStoryCreators,
                           detailName4: ItemType.event.rawValue.capitalized,
                           fetchDetails4: ComicBookRepositoryImpl.shared.getStoryEvents,
                           detailName5: ItemType.series.rawValue.capitalized,
                           fetchDetails5: ComicBookRepositoryImpl.shared.getStorySeries)
            )
}
