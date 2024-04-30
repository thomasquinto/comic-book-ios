//
//  ComicBookService.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookApi{    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
}
