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
    let repository: ComicBookRepository
    
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
                                
                ForEach(getItemTypesForDetail(itemType: item.itemType), id: \.self) { itemType in
                    ItemHListView(itemType: itemType, detailItem: item, repository: repository)
                }

                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width)
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
        }
        .scrollIndicators(.hidden)
    }
}

