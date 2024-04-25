//
//  HomeView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import SwiftUI
import CachedAsyncImage

struct ComicListView: View {
    @State var viewModel: ComicListViewModel = .init(
        repo: ComicBookRepositoryImpl.shared
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                Spacer()
                HStack{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            } else {
                comicList
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.getComics()
        }
    }
}

extension ComicListView {
    
    var comicList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.comics, id: \.id) { comic in
                    ComicItem(comicEntry: comic)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
    }
}

struct ComicItem: View {
    let comicEntry: Comic
    
    var body: some View {
        HStack{
            CachedAsyncImage(url: URL(string: comicEntry.thumbnailUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
            }

            Text(comicEntry.title)
                .padding(2)
            
            Spacer()
        }
        .padding(2)
    }
}
