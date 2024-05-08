//
//  ItemListView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import SwiftUI
import CachedAsyncImage

struct ItemVListView: View {
    
    let itemType: ItemType
    let fetchItems: (String, Int, Int) async throws -> [Item]
    let makeDetailView: (Item, ItemType) -> AnyView
    @State var viewModel: ItemVListViewModel

    init(itemName: ItemType,
         fetchItems: @escaping (String, Int, Int) async throws -> [Item],
         makeDetailView: @escaping (Item, ItemType) -> AnyView) {
        self.itemType = itemName
        self.fetchItems = fetchItems
        self.makeDetailView = makeDetailView
        self.viewModel = .init(fetchItems: fetchItems)
    }
    
    var body: some View {
        NavigationStack {
            itemList
                .navigationTitle(itemType.rawValue.capitalized)
                .searchable(text: $viewModel.searchText)
        }
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: viewModel.searchText) {
            Task {
                await viewModel.getItems(reset: true)
            }
        }
        .navigationTitle("Marvel Comics")
    }
}

extension ItemVListView {
        
    var itemList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in
                     NavigationLink {
                         makeDetailView(item, itemType)
                     } label: {
                         ItemLabel(item: item)
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
                                await viewModel.getItems(reset: false)
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
    }
}

struct ItemLabel: View {
    let item: Item
    
    var body: some View {
        HStack{
            CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 130)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 110, height: 130)
                    .cornerRadius(6)
            }

            Text(item.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(2)
            
            Spacer()
        }
        .padding(2)
    }
}
