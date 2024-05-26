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
    let useGrid: Bool
    let sizeFactor: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.6875 : 1.0
    
    @State var viewModel: ItemVListViewModel
    
    @EnvironmentObject var globalState: GlobalState
    @State private var hasInitializedFavoritesUpdated = false
    @State private var hasInitializedGlobalRefresh = false
    
    init(itemType: ItemType,
         detailItem: Item?,
         repository: ComicBookRepository,
         useGrid: Bool = true
    ) {
        self.itemType = itemType
        self.detailItem = detailItem
        self.repository = repository
        self.useGrid = useGrid
        _viewModel = State(initialValue: ItemVListViewModel(itemType: itemType, detailItem: detailItem, repository: repository))
    }
    
    var body: some View {
        
        let title = detailItem == nil ? itemType.rawValue.capitalized : itemType.rawValue.capitalized + " - " + detailItem!.name
            
        NavigationStack {
            let itemCollectionView = useGrid ? AnyView(itemGrid) : AnyView(itemList)
            if ![.favorite, .story].contains(itemType) {
                itemCollectionView
                    .navigationTitle(title)
                    .searchable(text: $viewModel.searchText)
                    .onReceive(viewModel.$debouncedSearchText) { searchText in
                        viewModel.searchText = searchText
                        viewModel.resetItems()
                    }
            } else {
                itemCollectionView
                    .navigationTitle(title)
            }
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
            if ![.favorite, .story].contains(itemType) {
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
        .onReceive(globalState.$favoritesUpdated) { favoritesUpdated in
            if (!hasInitializedFavoritesUpdated) {
                hasInitializedFavoritesUpdated = true
                return
            }
            if itemType == .favorite {
                viewModel.resetItems()
            }
        }
        .onReceive(globalState.$globalRefresh) { globalRefresh in
            if (!hasInitializedGlobalRefresh) {
                hasInitializedGlobalRefresh = true
                return
            }
            viewModel.resetItems()
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
                        ItemLabelRow(item: item, sizeFactor: sizeFactor)
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
        .refreshable {
            viewModel.resetItems(fetchFromRemote: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)

    }
    
    var itemGrid : some View {
        GeometryReader { geometry in
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: Int(geometry.size.width / ((160 * sizeFactor) + 10)))
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            ItemDetailView(item: item, repository: repository)
                        } label: {
                            ItemLabel(item: item, sizeFactor: sizeFactor)
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
            .refreshable {
                viewModel.resetItems(fetchFromRemote: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden)
        }
    }
}

struct ItemLabel: View {
    let item: Item
    let sizeFactor: CGFloat

    var body: some View {
        VStack{
            CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160 * sizeFactor, height: 240 * sizeFactor)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 160 * sizeFactor, height: 240 * sizeFactor)
                    .cornerRadius(6)
            }

            Spacer()

            Text(item.name)
                .lineLimit(1)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(2)
        }
        .frame(width: 160 * sizeFactor)
        .padding(2)
    }
}

struct ItemLabelRow: View {
    let item: Item
    let sizeFactor: CGFloat

    var body: some View {
        HStack{
            CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160 * sizeFactor, height: 240 * sizeFactor)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 160 * sizeFactor, height: 240 * sizeFactor)
                    .cornerRadius(6)
            }

            Text(item.name)
                .fontWeight(.bold)
                .padding(2)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .padding(.trailing, 8)
        }
        .contentShape(Rectangle()) // Makes the entire HStack tappable
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
    }
    

}
