//
//  ComicBookRepository.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookRepository{
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
}
