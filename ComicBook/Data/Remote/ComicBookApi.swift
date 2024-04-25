//
//  ComicBookService.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookApi{
    func getComics(offset: Int, limit: Int) async throws -> ComicsResponseDto
}
