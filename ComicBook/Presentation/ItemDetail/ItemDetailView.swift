//
//  ItemDetailView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/26/24.
//

import SwiftUI
import CachedAsyncImage

struct ItemDetailView: View {
    let item: Item
    let makeDetailView: (Item, ItemType) -> AnyView
    let detailName1: String
    let fetchDetails1: (Int, Int, Int, String?) async throws -> [Item]
    let detailName2: String
    let fetchDetails2: (Int, Int, Int, String?) async throws -> [Item]
    let detailName3: String
    let fetchDetails3: (Int, Int, Int, String?) async throws -> [Item]
    let detailName4: String
    let fetchDetails4: (Int, Int, Int, String?) async throws -> [Item]
    let detailName5: String?
    let fetchDetails5: ((Int, Int, Int, String?) async throws -> [Item])?

    var body: some View {
        ScrollView {
            // Hero Image
            CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 600) // Adjust height as needed
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 600) // Adjust height as needed
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(item.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Description
                Text(item.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                                
                ItemHListView(id: item.id, name: detailName1, fetchDetails: fetchDetails1, makeDetailView: makeDetailView)
                ItemHListView(id: item.id, name: detailName2, fetchDetails: fetchDetails2, makeDetailView: makeDetailView)
                ItemHListView(id: item.id, name: detailName3, fetchDetails: fetchDetails3, makeDetailView: makeDetailView)
                ItemHListView(id: item.id, name: detailName4, fetchDetails: fetchDetails4, makeDetailView: makeDetailView)
                if let detailName5 {
                    ItemHListView(id: item.id, name: detailName5, fetchDetails: fetchDetails5!, makeDetailView: makeDetailView)
                }

                Spacer()
            }
            .scenePadding()
            .frame(maxWidth: UIScreen.main.bounds.size.width)
        }            
        .scrollIndicators(.hidden)
    }
}

