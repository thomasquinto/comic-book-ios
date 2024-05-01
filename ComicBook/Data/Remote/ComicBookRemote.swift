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
    
    private func getResponse<T>(type: T.Type, urlEntity: String, queryItems: [URLQueryItem], offset: Int, limit: Int) async throws -> [Entity] where T: MappedEntity {
        let baseUrl = "https://gateway.marvel.com:443/v1/public/\(urlEntity)"
        let publicKey = "***REMOVED***"
        let privateKey = "***REMOVED***"
        
        let timestamp = Date().timeIntervalSince1970
        var queryItemArray = [URLQueryItem]()
        queryItemArray.append(URLQueryItem(name: "apikey", value: publicKey))
        queryItemArray.append(URLQueryItem(name: "ts", value: String(timestamp)))
        queryItemArray.append(URLQueryItem(name: "hash", value: generateHash(ts: timestamp, publicKey: publicKey, privateKey: privateKey)))
        queryItemArray.append(URLQueryItem(name: "offset", value: String(offset)))
        queryItemArray.append(URLQueryItem(name: "limit", value: String(limit)))
        
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
                T.toEntity()
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
    
    private func getDetails<T>(type: T.Type, prefix: String, urlEntity: String, id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] where T: MappedEntity {
        var queryItems = [URLQueryItem]()
        if let orderBy {
            queryItems.append(URLQueryItem(name: "orderBy", value: orderBy))
        }
        
        if urlEntity.isEmpty {
            return try await getResponse(type: type.self, urlEntity: "\(prefix)", queryItems: queryItems, offset: offset, limit: limit)
        }
        
        return try await getResponse(type: type.self, urlEntity: "\(prefix)/\(id)/\(urlEntity)", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "name"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: CharacterDto.self, urlEntity: "characters", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CharacterDto.self, prefix:"characters", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"characters", urlEntity: "comics", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"characters", urlEntity: "events", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: SeriesDto.self, prefix:"characters", urlEntity: "series", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"characters", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "title"))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "titleStartsWith", value: titleStartsWith))
        }
        
        return try await getResponse(type: ComicDto.self, urlEntity: "comics", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"comics", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CharacterDto.self, prefix:"comics", urlEntity: "characters", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CreatorDto.self, prefix:"comics", urlEntity: "creators", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"comics", urlEntity: "events", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"comics", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "lastName"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: CreatorDto.self, urlEntity: "creators", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CreatorDto.self, prefix:"creators", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"creators", urlEntity: "comics", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"creators", urlEntity: "events", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: SeriesDto.self, prefix:"creators", urlEntity: "series", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"creators", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "name"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: EventDto.self, urlEntity: "events", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"events", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CharacterDto.self, prefix:"events", urlEntity: "characters", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"events", urlEntity: "comics", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CreatorDto.self, prefix:"events", urlEntity: "creators", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: SeriesDto.self, prefix:"events", urlEntity: "series", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"events", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "title"))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "titleStartsWith", value: titleStartsWith))
        }
        
        return try await getResponse(type: SeriesDto.self, urlEntity: "series", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: SeriesDto.self, prefix:"series", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }

    func getSeriesCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CharacterDto.self, prefix:"series", urlEntity: "characters", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"series", urlEntity: "comics", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CreatorDto.self, prefix:"series", urlEntity: "creators", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"series", urlEntity: "events", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"series", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }

    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "-modified"))
        
        return try await getResponse(type: StoryDto.self, urlEntity: "stories", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"stories", urlEntity: "", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }

    func getStoryCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CharacterDto.self, prefix:"stories", urlEntity: "characters", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: ComicDto.self, prefix:"stories", urlEntity: "comics", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: CreatorDto.self, prefix:"stories", urlEntity: "creators", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: EventDto.self, prefix:"stories", urlEntity: "events", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStorySeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await getDetails(type: StoryDto.self, prefix:"stories", urlEntity: "stories", id: id, offset: offset, limit: limit, orderBy: orderBy)
    }

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
