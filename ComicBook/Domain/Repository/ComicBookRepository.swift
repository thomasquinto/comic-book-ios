//
//  ComicBookRepository.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookRepository{
    
    func getCharacters(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]
    
    func getComics(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]
    
    func getCreators(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]
    
    func getEvents(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]

    func getSeries(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]
    
    func getStories(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item]

}
