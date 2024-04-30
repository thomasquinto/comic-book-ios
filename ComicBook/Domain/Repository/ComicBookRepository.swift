//
//  ComicBookRepository.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookRepository{
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCharacterComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCharacterEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCharacterSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCharacterStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getCreatorComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCreatorEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCreatorSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getCreatorStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getEventCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getEventComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getEventCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getEventSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getEventStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]

    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getSeriesCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getSeriesComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getSeriesCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getSeriesEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getSeriesStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity]
    func getStoryCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getStoryComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getStoryCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getStoryEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    func getStorySeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity]
    
}
