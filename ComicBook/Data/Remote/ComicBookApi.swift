//
//  ComicBookApi.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

protocol ComicBookApi{    
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCharacterComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCharacterEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCharacterSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCharacterStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCreatorComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCreatorEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCreatorSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getCreatorStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getEventCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getEventComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getEventCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getEventSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getEventStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]

    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getSeriesCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getSeriesComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getSeriesCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getSeriesEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getSeriesStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item]
    func getStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getStoryCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getStoryComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getStoryCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getStoryEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    func getStorySeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item]
    
}
