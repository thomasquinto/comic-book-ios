//
//  ComicBookRepository.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookRepository{
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
}
