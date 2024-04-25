//
//  ComicBookRepositoryImpl.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicBookRepositoryImpl: ComicBookRepository {
    
    fileprivate let remote: ComicBookRemote
    
    private init(remote: ComicBookRemote){
        self.remote = remote
    }
    
    /* TODO: Use dependency injection properly
    typealias ComicBookInstance = (ComicBookRemote) -> ComicBookRepositoryImpl

    static let sharedInstance: ComicBookInstance = { remoteRepo in
        return ComicBookRepositoryImpl(remote: remoteRepo)
    }
     */
    static let shared: ComicBookRepository = ComicBookRepositoryImpl(remote: ComicBookRemote.shared)
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Comic] {
        let comicsResponseDto = try await remote.getComics(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
        return comicsResponseDto.data.results.map{ comicDto in
            comicDto.toComic
        }
    }
}
