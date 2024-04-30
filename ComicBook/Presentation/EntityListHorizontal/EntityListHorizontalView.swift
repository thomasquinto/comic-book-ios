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
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Entity]
    @State var viewModel: EntityListHorizontalViewModel

    init(id: Int, 
         fetchDetails: @escaping (Int, Int, Int, String?) async throws -> [Entity]) {
        self.id = id
        self.fetchDetails = fetchDetails
        self.viewModel = .init(id: id, fetchDetails: fetchDetails)
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.entities) { entity in
                    EntityItemView(entity: entity)
                }        
            }
            .task {
                await viewModel.getEntities(reset: false)
            }
        }
        .scrollIndicators(.hidden)
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
