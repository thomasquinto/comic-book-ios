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
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getComics(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getCharacters(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
}
