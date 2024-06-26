//
//  HomeView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI

struct HomeView: View {
    
    let repository: ComicBookRepository
    @State var viewModel: HomeViewModel
    @State var globalState = GlobalState()

    init(repository: ComicBookRepository) {
        self.repository = repository
        _viewModel = State(initialValue: HomeViewModel(repository: repository))
    }
    
    enum CoordinateSpaces {
        case scrollView
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {

                let aspectRatio = UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
                    
                ParallaxHeader (
                    coordinateSpace: CoordinateSpaces.scrollView,
                    defaultHeight: aspectRatio > 0.7 ? UIScreen.main.bounds.height / 1.3 : UIScreen.main.bounds.height / 2
                ) {
                    Image("hero_image")
                        .resizable()
                        .scaledToFill()
                }
                
                VStack {
                    ForEach(getItemTypesForHome(), id: \.self) { itemType in
                        ItemLinkView(itemType: itemType, detailItem: nil)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
            
            }
            .refreshable {
                Task {
                    await viewModel.refresh()
                    globalState.globalRefresh.toggle()
                }
            }
            .coordinateSpace(name: CoordinateSpaces.scrollView)
            .edgesIgnoringSafeArea(.top)
            .scrollIndicators(.hidden)
        }
        .environment(globalState)
    }
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
            let alpha = min(((proxy.size.height - offset*2.0)/proxy.size.height), 1)
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
            return -frame.minY * 0.6
        }
        return -frame.minY
    }
    
    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.minY)
    }
}

@Observable
class GlobalState {
    var globalRefresh: Bool = false
    var favoritesUpdated: Bool = false
    
    init() {}
}
