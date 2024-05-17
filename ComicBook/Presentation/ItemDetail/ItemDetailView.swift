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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
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
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Description
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    ForEach(getItemTypesForDetail(itemType: item.itemType), id: \.self) { itemType in
                        ItemLinkView(itemType: itemType, detailItem: item)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.8))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            }
        }
    }
}

