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
    let detailItem: Item?
    let repository: ComicBookRepository
    
    @State var viewModel: ItemVListViewModel

    init(itemType: ItemType,
         detailItem: Item?,
         repository: ComicBookRepository
    ) {
        self.itemType = itemType
        self.detailItem = detailItem
        self.repository = repository
        _viewModel = State(initialValue: ItemVListViewModel(itemType: itemType, detailItem: detailItem, repository: repository))
    }
    
    var body: some View {
        
        let title = detailItem == nil ? itemType.rawValue.capitalized : itemType.rawValue.capitalized + " - " + detailItem!.title
        
        NavigationStack {
            itemList
                .navigationTitle(title)
                .searchable(text: $viewModel.searchText)
        }
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: viewModel.searchText) {
            viewModel.resetItems()
        }
        .navigationTitle("Marvel Comics")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showBottomSheet.toggle()
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                .sheet(isPresented: $viewModel.showBottomSheet) {
                    bottomSheet
                        .presentationDetents([.fraction(0.3)])
                }
            }
        }
    }
}

extension ItemVListView {
        
    var itemList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in
                     NavigationLink {
                         ItemDetailView(item: item, repository: repository)
                     } label: {
                         ItemLabel(item: item)
                     }
                    .buttonStyle(PlainButtonStyle())
                }
                if !viewModel.hasNoMore {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            Task {
                                await viewModel.getItems()
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
                    .frame(width: 110, height: 165)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 110, height: 165)
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

extension ItemVListView {
    
    var bottomSheet: some View {
        VStack(alignment: .leading) {
            Text("Sort")
                .frame(maxWidth: .infinity, alignment: .center)
                .fontWeight(.bold)
            ForEach(getOrderByValues(itemType: itemType), id: \.self) { orderBy in
                Button {
                    viewModel.showBottomSheet.toggle()
                    viewModel.orderBy = orderBy
                    viewModel.resetItems()
                } label: {
                    HStack {
                        Image(systemName: viewModel.orderBy == orderBy ?  "circle.fill" : "circle")
                        Text(getOrderByName(orderBy: orderBy))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(alignment: .leading)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
    

}
