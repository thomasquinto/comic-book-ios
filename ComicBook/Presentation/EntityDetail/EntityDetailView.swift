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
    let fetchDetails1: (Int, Int, Int, String?) async throws -> [Entity]
    let fetchDetails2: (Int, Int, Int, String?) async throws -> [Entity]
    let fetchDetails3: (Int, Int, Int, String?) async throws -> [Entity]
    let fetchDetails4: (Int, Int, Int, String?) async throws -> [Entity]
    
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
                                
                EntityListHorizontalView(id: entity.id, fetchDetails: fetchDetails1)
                EntityListHorizontalView(id: entity.id, fetchDetails: fetchDetails2)
                EntityListHorizontalView(id: entity.id, fetchDetails: fetchDetails3)
                EntityListHorizontalView(id: entity.id, fetchDetails: fetchDetails4)

                Spacer()
            }.scenePadding()
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
