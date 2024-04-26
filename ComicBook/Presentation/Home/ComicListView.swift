//
//  ComicListView.swift
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
        NavigationStack {
            comicList
        }
        .searchable(text: $viewModel.searchText)
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: viewModel.searchText) {
            Task {
                await viewModel.getComics(reset: true)
            }
        }
    }
}

extension ComicListView {
        
    var comicList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.comics) { comic in
                     NavigationLink {
                         ComicDetailView(viewModel: .init(comic: comic))
                     } label: {
                         ComicItem(comicEntry: comic)
                     }
                    .buttonStyle(PlainButtonStyle())
                }
                if !viewModel.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .onAppear {
                            Task {
                                await viewModel.getComics(reset: false)
                            }
                        }
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
