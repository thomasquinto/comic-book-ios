//
//  HomeView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI

struct HomeView: View {
    
    enum CoordinateSpaces {
        case scrollView
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {

            ParallaxHeader (
                coordinateSpace: CoordinateSpaces.scrollView,
                defaultHeight: 400
            ) {
                Image("hero_image")
                .resizable()
                .scaledToFill()
            }
            
            VStack {
                ItemLinkView(itemType: .comic, fetchDetails: ComicBookRepositoryImpl.shared.getComics, fetchItems: ComicBookRepositoryImpl.shared.getComics)
                ItemLinkView(itemType: .character, fetchDetails: ComicBookRepositoryImpl.shared.getCharacters, fetchItems: ComicBookRepositoryImpl.shared.getCharacters)
                ItemLinkView(itemType: .series, fetchDetails: ComicBookRepositoryImpl.shared.getSeries, fetchItems: ComicBookRepositoryImpl.shared.getSeries)
                ItemLinkView(itemType: .creator, fetchDetails: ComicBookRepositoryImpl.shared.getCreators, fetchItems: ComicBookRepositoryImpl.shared.getCreators)
                ItemLinkView(itemType: .event, fetchDetails: ComicBookRepositoryImpl.shared.getEvents, fetchItems: ComicBookRepositoryImpl.shared.getEvents)
                ItemLinkView(itemType: .story, fetchDetails: ComicBookRepositoryImpl.shared.getStories, fetchItems: ComicBookRepositoryImpl.shared.getStories)
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            
            }
            .coordinateSpace(name: CoordinateSpaces.scrollView)
            .edgesIgnoringSafeArea(.top)
            .scrollIndicators(.hidden)
        }
    }
}

struct ItemLinkView : View {
    let itemType: ItemType
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Item]
    let fetchItems: (String, Int, Int) async throws -> [Item]

    var body: some View {
        NavigationLink {
            ItemVListView(
                itemName: itemType,
                fetchItems: fetchItems,
                makeDetailView: makeDetailView
            )
        } label: {
            ItemHListView(id: 0, name: itemType.rawValue.capitalized, fetchDetails: fetchDetails, makeDetailView: makeDetailView)
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

struct ParallaxHeader<Content: View, Space: Hashable>: View {
    let content: () -> Content
    let coordinateSpace: Space
    let defaultHeight: CGFloat

    init(
        coordinateSpace: Space,
        defaultHeight: CGFloat,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content
        self.coordinateSpace = coordinateSpace
        self.defaultHeight = defaultHeight
    }
    
    var body: some View {
        GeometryReader { proxy in
            let offset = offset(for: proxy)
            let heightModifier = heightModifier(for: proxy)
            let alpha = min(((proxy.size.height - offset*1.5)/proxy.size.height), 1)
            //let blurRadius = min(heightModifier / 20, max(10, heightModifier / 20))

            content()
                .edgesIgnoringSafeArea(.horizontal)
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + heightModifier
                )
                .offset(y: offset)
                .opacity(alpha)
                //.blur(radius: blurRadius)
        }.frame(height: defaultHeight)
    }
    
    private func offset(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        if frame.minY < 0 {
            return -frame.minY * 0.8
        }
        return -frame.minY
    }
    
    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.minY)
    }
}
