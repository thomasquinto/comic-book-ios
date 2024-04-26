//
//  ComicDetailViewModel.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/26/24.
//

import Foundation

@Observable
class ComicDetailViewModel {
    
    let comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
    }
    
}
