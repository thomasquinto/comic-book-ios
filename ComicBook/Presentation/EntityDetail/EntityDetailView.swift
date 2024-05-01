//
//  ComicDetailView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/26/24.
//

import SwiftUI
import CachedAsyncImage

struct EntityDetailView: View {
    let entity: Entity
    let makeDetailView: (Entity, String) -> AnyView
    let detailName1: String
    let fetchDetails1: (Int, Int, Int, String?) async throws -> [Entity]
    let detailName2: String
    let fetchDetails2: (Int, Int, Int, String?) async throws -> [Entity]
    let detailName3: String
    let fetchDetails3: (Int, Int, Int, String?) async throws -> [Entity]
    let detailName4: String
    let fetchDetails4: (Int, Int, Int, String?) async throws -> [Entity]
    let detailName5: String?
    let fetchDetails5: ((Int, Int, Int, String?) async throws -> [Entity])?

    var body: some View {
        ScrollView {
            // Hero Image
            CachedAsyncImage(url: URL(string: entity.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 400) // Adjust height as needed
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 400) // Adjust height as needed
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(entity.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Description
                Text(entity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                                
                EntityListHorizontalView(id: entity.id, name: detailName1, fetchDetails: fetchDetails1, makeDetailView: makeDetailView)
                EntityListHorizontalView(id: entity.id, name: detailName2, fetchDetails: fetchDetails2, makeDetailView: makeDetailView)
                EntityListHorizontalView(id: entity.id, name: detailName3, fetchDetails: fetchDetails3, makeDetailView: makeDetailView)
                EntityListHorizontalView(id: entity.id, name: detailName4, fetchDetails: fetchDetails4, makeDetailView: makeDetailView)
                if let detailName5 {
                    EntityListHorizontalView(id: entity.id, name: detailName5, fetchDetails: fetchDetails5!, makeDetailView: makeDetailView)
                }

                Spacer()
            }
            .scrollIndicators(.hidden)
            .scenePadding()
            .frame(maxWidth: UIScreen.main.bounds.size.width)
        }
    }
}

/*
#Preview {
    EntityDetailView(entity: .init(
                        id: 1,
                        title: "The Amazing Spider-Man (2022) #47 (Variant)",
                        description: "After the events of WEB OF SPIDER-MAN #1, Chasm is on the loose!  Spider-Man better track down his erstwhile clone and Hallows' Eve ASAP! We're getting closer to AMAZING SPIDER-MAN #50!",
                        imageUrl: "http://i.annihil.us/u/prod/marvel/i/mg/4/30/6615461499ffc.jpg",
                        date: Date()))
}
*/
