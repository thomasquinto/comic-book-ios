//
//  EntityListHorizontalView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI
import CachedAsyncImage

struct EntityListHorizontalView: View {
    let id: Int
    let name: String
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Entity]
    let makeDetailView: (Entity, String) -> AnyView
    @State var viewModel: EntityListHorizontalViewModel

    init(id: Int,
         name: String,
         fetchDetails: @escaping (Int, Int, Int, String?) async throws -> [Entity],
         makeDetailView: @escaping (Entity, String) -> AnyView
    ) {
        self.id = id
        self.name = name
        self.fetchDetails = fetchDetails
        self.makeDetailView = makeDetailView
        self.viewModel = .init(id: id, fetchDetails: fetchDetails)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.entities.isEmpty {
                HStack {
                    Text(name)
                        .font(.title3)
                    if id == 0 {
                        Spacer()
                        Text("See more")
                            .font(.callout)
                    }
                }
            }
                
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.entities) { entity in
                        NavigationLink {
                            makeDetailView(entity, entity.entityName)
                        } label: {
                            EntityItemView(entity: entity)
                        }
                       .buttonStyle(PlainButtonStyle())
                    }
                }
                .task {
                    await viewModel.getEntities(reset: false)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct EntityItemView: View {
    let entity: Entity

    var body: some View {
        VStack{
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

            Spacer()

            Text(entity.title)
                .font(.caption)
                .padding(2)
        }
        .frame(width: 100, height: 120)
        .padding(2)
    }
}
