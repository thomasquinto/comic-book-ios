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
    @State var viewModel: ItemDetailViewModel
    @EnvironmentObject var globalState: GlobalState

    init(item: Item, repository: ComicBookRepository) {
        self.item = item
        self.repository = repository
        _viewModel = State(initialValue: ItemDetailViewModel(item: item, repository: repository))
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    // Hero Image
                    CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: UIScreen.main.bounds.height / 1.3)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(maxHeight: UIScreen.main.bounds.height / 1.3)
                            .clipped()
                    }
                    
                    Button {
                        Task {
                            await viewModel.toggleFavorite()
                            globalState.favoritesUpdated.toggle()
                        }
                    } label: {
                        Image(
                            systemName: viewModel.isFavorite ?
                                "heart.fill" : "heart"
                        )
                        .foregroundColor(
                            viewModel.isFavorite ?
                                .red : .primary
                        )
                        .frame(width: 40, height: 40)
                        .background(.background.opacity(0.8))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(item.name)
                        .font(.title2)
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
                    .foregroundColor(.primary)
                    .background(.background.opacity(0.8))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            }
        }
        .onAppear() {
            Task {
                await viewModel.initFavorite()
            }
        }
    }

}

// This re-enables the swipe back gesture which gets disabled when hiding system nav bar back buton
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}


