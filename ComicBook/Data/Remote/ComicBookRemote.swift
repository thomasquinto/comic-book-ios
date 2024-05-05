//
//  ComicBookRemote.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation
import CryptoKit

struct ComicBookRemote{
    private init() {}
    
    static let shared = ComicBookRemote()
}

extension ComicBookRemote: ComicBookApi{
    
    private func getResponse<T>(type: T.Type, urlEntity: String, queryItems: [URLQueryItem], offset: Int, limit: Int) async throws -> [Item] where T: MappedItem {
        let baseUrl = "https://gateway.marvel.com:443/v1/public/\(urlEntity)"
        let publicKey = "***REMOVED***"
        let privateKey = "***REMOVED***"

        let timestamp = Date().timeIntervalSince1970
        var queryItemArray = [URLQueryItem]()
        queryItemArray.append(URLQueryItem(name: URLKey.apikey.rawValue, value: publicKey))
        queryItemArray.append(URLQueryItem(name: URLKey.ts.rawValue, value: String(timestamp)))
        queryItemArray.append(URLQueryItem(name: URLKey.hash.rawValue, value: generateHash(ts: timestamp, publicKey: publicKey, privateKey: privateKey)))
        queryItemArray.append(URLQueryItem(name: URLKey.offset.rawValue, value: String(offset)))
        queryItemArray.append(URLQueryItem(name: URLKey.limit.rawValue, value: String(limit)))
        
        for queryItem in queryItems{
            queryItemArray.append(queryItem)
        }
        
        let url = URL(string: baseUrl)
        
        guard let url = url else {
            throw NetworkError.invalidURL("Invalid URL: \(baseUrl)")
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL("Invalid URL: \(baseUrl)")
        }
        urlComponents.queryItems = queryItemArray
        guard let componentsUrl = urlComponents.url else {
            throw NetworkError.invalidURL("Invalid URL query items")
        }
        
        let request = URLRequest(url: componentsUrl)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse("Invalid Response")
        }
        
        print(response.url?.absoluteString ?? "Invalid URL")

        if response.statusCode != 200 {
            throw NetworkError.invalidResponse("Invalid Response with status code: \(response.statusCode)")
        }
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ResponseDto<T>.self, from: data)
            return response.data.results.map{ T in
                T.toItem()
            }
        } catch let DecodingError.dataCorrupted(context) {
            throw NetworkError.decodingError("\(context.debugDescription), codingPath: \(context.codingPath)")
        } catch let DecodingError.keyNotFound(_, context) {
            throw NetworkError.decodingError("\(context.debugDescription), codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(_, context) {
            throw NetworkError.decodingError("\(context.debugDescription), codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(_, context)  {
            throw NetworkError.decodingError("\(context.debugDescription), codingPath: \(context.codingPath)")
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    private func generateHash(ts: Double, publicKey: String, privateKey: String) -> String{
        return (String(ts) + privateKey + publicKey).md5
    }
    
    private func getDetails<T>(type: T.Type, prefix: String, urlEntity: String, id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] where T: MappedItem {
        var queryItems = [URLQueryItem]()
        if let orderBy {
            queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: orderBy))
        }
        
        if urlEntity.isEmpty {
            return try await getResponse(type: type.self, urlEntity: "\(prefix)", queryItems: queryItems, offset: offset, limit: limit)
        }
        
        return try await getResponse(type: type.self, urlEntity: "\(prefix)/\(id)/\(urlEntity)", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: OrderBy.name.rawValue))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: URLKey.nameStartsWith.rawValue, value: nameStartsWith))
        }
        
        return try await getResponse(type: CharacterDto.self, urlEntity: ItemType.character.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CharacterDto.self, prefix:ItemType.character.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getCharacterComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.character.rawValue, urlEntity: ItemType.comic.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.title.rawValue)
    }
    
    func getCharacterEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.character.rawValue, urlEntity: ItemType.event.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: SeriesDto.self, prefix:ItemType.character.rawValue, urlEntity: ItemType.series.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.character.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: OrderBy.title.rawValue))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: URLKey.titleStartsWith.rawValue, value: titleStartsWith))
        }
        
        return try await getResponse(type: ComicDto.self, urlEntity: ItemType.comic.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.comic.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CharacterDto.self, prefix:ItemType.comic.rawValue, urlEntity: ItemType.character.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CreatorDto.self, prefix:ItemType.comic.rawValue, urlEntity: ItemType.creator.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.comic.rawValue, urlEntity: ItemType.event.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.comic.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: "lastName"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: URLKey.nameStartsWith.rawValue, value: nameStartsWith))
        }
        
        return try await getResponse(type: CreatorDto.self, urlEntity: ItemType.creator.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CreatorDto.self, prefix:ItemType.creator.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getCreatorComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.creator.rawValue, urlEntity: ItemType.comic.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.title.rawValue)
    }
    
    func getCreatorEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.creator.rawValue, urlEntity: ItemType.event.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: SeriesDto.self, prefix:ItemType.creator.rawValue, urlEntity: ItemType.series.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.creator.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: OrderBy.name.rawValue))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: URLKey.nameStartsWith.rawValue, value: nameStartsWith))
        }
        
        return try await getResponse(type: EventDto.self, urlEntity: ItemType.event.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.event.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getEventCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CharacterDto.self, prefix:ItemType.event.rawValue, urlEntity: ItemType.character.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.event.rawValue, urlEntity: ItemType.comic.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.title.rawValue)
    }
    
    func getEventCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CreatorDto.self, prefix:ItemType.event.rawValue, urlEntity: ItemType.creator.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: SeriesDto.self, prefix:ItemType.event.rawValue, urlEntity: ItemType.series.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.event.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }
    
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: OrderBy.title.rawValue))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: URLKey.titleStartsWith.rawValue, value: titleStartsWith))
        }
        
        return try await getResponse(type: SeriesDto.self, urlEntity: ItemType.series.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: SeriesDto.self, prefix:ItemType.series.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }

    func getSeriesCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CharacterDto.self, prefix:ItemType.series.rawValue, urlEntity: ItemType.character.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.series.rawValue, urlEntity: ItemType.comic.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.title.rawValue)
    }
    
    func getSeriesCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CreatorDto.self, prefix:ItemType.series.rawValue, urlEntity: ItemType.creator.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.series.rawValue, urlEntity: ItemType.event.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.series.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }

    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Item] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: OrderBy.modifiedDesc.rawValue))
        
        return try await getResponse(type: StoryDto.self, urlEntity: ItemType.story.rawValue, queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.story.rawValue, urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.modifiedDesc.rawValue)
    }

    func getStoryCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CharacterDto.self, prefix:ItemType.story.rawValue, urlEntity: ItemType.character.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: ComicDto.self, prefix:ItemType.story.rawValue, urlEntity: ItemType.comic.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy ?? OrderBy.title.rawValue)
    }
    
    func getStoryCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: CreatorDto.self, prefix:ItemType.story.rawValue, urlEntity: ItemType.creator.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: EventDto.self, prefix:ItemType.story.rawValue, urlEntity: ItemType.event.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStorySeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Item] {
        return try await getDetails(type: StoryDto.self, prefix:ItemType.story.rawValue, urlEntity: ItemType.story.rawValue, id: id, offset: offset, limit: limit, orderBy: orderBy)
    }

}

enum URLKey: String {
    case ts
    case apikey
    case hash
    case limit
    case offset
    case orderBy
    case titleStartsWith
    case nameStartsWith
}

enum OrderBy: String {
    case name
    case title
    case lastName
    case modifiedDesc = "-modified"
}

enum NetworkError: Error {
    case invalidURL(_ errorMessage: String)
    case invalidResponse(_ errorMessage: String)
    case decodingError(_ errorMessage: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(errorMessage: let errorMessage):
            return NSLocalizedString(errorMessage, comment: "Invalid URL message")
        case .invalidResponse(errorMessage: let errorMessage):
            return NSLocalizedString(errorMessage, comment: "Invalid Response message")
        case .decodingError(errorMessage: let errorMessage):
            return NSLocalizedString(errorMessage, comment: "Decoding Error message")
        }
    }
}

extension String{
    var md5: String{
        let data = Data(self.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map{ String(format: "%02hhx", $0) }.joined()
    }
}
