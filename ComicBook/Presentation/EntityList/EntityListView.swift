//
//  EntityListView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import SwiftUI
import CachedAsyncImage

struct EntityListView: View {
    
    let entityName: String
    let fetchEntities: (String, Int, Int) async throws -> [Entity]
    let makeDetailView: (Entity, String) -> AnyView
    @State var viewModel: EntityListViewModel

    init(entityName: String,
         fetchEntities: @escaping (String, Int, Int) async throws -> [Entity],
         makeDetailView: @escaping (Entity, String) -> AnyView) {
        self.entityName = entityName
        self.fetchEntities = fetchEntities
        self.makeDetailView = makeDetailView
        self.viewModel = .init(fetchEntities: fetchEntities)
    }
    
    var body: some View {
        NavigationStack {
            entityList
                .navigationTitle(entityName)
                .searchable(text: $viewModel.searchText)
        }
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: viewModel.searchText) {
            Task {
                await viewModel.getEntities(reset: true)
            }
        }
        .navigationTitle("Marvel Comics")
    }
}

extension EntityListView {
        
    var entityList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.entities) { entity in
                     NavigationLink {
                         makeDetailView(entity, entityName)
                     } label: {
                         EntityItem(entity: entity)
                     }
                    .buttonStyle(PlainButtonStyle())
                }
                if !viewModel.hasNoMore {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .onAppear {
                            Task {
                                await viewModel.getEntities(reset: false)
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
    }
}

struct EntityItem: View {
    let entity: Entity
    
    var body: some View {
        HStack{
            CachedAsyncImage(url: URL(string: entity.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
            }

            Text(entity.title)
                .padding(2)
            
            Spacer()
        }
        .padding(2)
    }
}
