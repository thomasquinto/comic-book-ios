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
    
    func getResponse<T>(type: T.Type, urlEntity: String, queryItems: [URLQueryItem], offset: Int, limit: Int) async throws -> [Entity] where T: EntityMapper {
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
        
        print("Request URL:", response.url?.absoluteString ?? "N/A")

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
    
    func generateHash(ts: Double, publicKey: String, privateKey: String) -> String{
        return (String(ts) + privateKey + publicKey).md5
    }

    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "title"))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "titleStartsWith", value: titleStartsWith))
        }
        
        return try await getResponse(type: ComicDto.self, urlEntity: "comics", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "name"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: CharacterDto.self, urlEntity: "characters", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "title"))
        if !titleStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "titleStartsWith", value: titleStartsWith))
        }
        
        return try await getResponse(type: SeriesDto.self, urlEntity: "series", queryItems: queryItems, offset: offset, limit: limit)
    }
    

    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "name"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: EventDto.self, urlEntity: "events", queryItems: queryItems, offset: offset, limit: limit)
    }

    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "-modified"))
        
        return try await getResponse(type: StoryDto.self, urlEntity: "stories", queryItems: queryItems, offset: offset, limit: limit)
    }
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "orderBy", value: "lastName"))
        if !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return try await getResponse(type: CreatorDto.self, urlEntity: "creators", queryItems: queryItems, offset: offset, limit: limit)
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
