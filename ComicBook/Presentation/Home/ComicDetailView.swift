//
//  ComicDetailView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/26/24.
//

import SwiftUI
import CachedAsyncImage

struct ComicDetailView: View {
    @State var viewModel: ComicDetailViewModel
    
    var body: some View {
        ScrollView {
            // Hero Image
            CachedAsyncImage(url: URL(string: viewModel.comic.thumbnailUrl)) { image in
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
                Text(viewModel.comic.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Description
                Text(viewModel.comic.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }.scenePadding()
        }
    }
}

#Preview {
    ComicDetailView(viewModel: .init(comic: .init(
                        id: 1,
                        title: "The Amazing Spider-Man (2022) #47 (Variant)",
                        description: "After the events of WEB OF SPIDER-MAN #1, Chasm is on the loose!  Spider-Man better track down his erstwhile clone and Hallows' Eve ASAP! We're getting closer to AMAZING SPIDER-MAN #50!",
                        thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/4/30/6615461499ffc.jpg",
                        modified: Date())))
}
