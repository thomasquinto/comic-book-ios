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
            
    private func generateHash(ts: Double, publicKey: String, privateKey: String) -> String{
        return (String(ts) + privateKey + publicKey).md5
    }
    
    private func getItems<T>(
        dtoType: T.Type,
        itemType: ItemType,
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] where T: MappedItem {
        
        let urlSuffix = id == 0 || prefix.isEmpty ? "\(itemType.rawValue)" : "\(prefix)/\(id)/\(itemType.rawValue)"
           
        let baseUrl = "***REMOVED***\(urlSuffix)"
        //let baseUrl = "http://192.168.1.101:8080/v1/public/\(urlSuffix)"
        //let baseUrl = "https://gateway.marvel.com/v1/public/\(urlSuffix)"
        let publicKey = "MARVEL_API_PUBLIC_KEY"
        let privateKey = "MARVEL_API_PRIVATE_KEY"

        let timestamp = Date().timeIntervalSince1970
        var queryItemArray = [URLQueryItem]()
        queryItemArray.append(URLQueryItem(name: URLKey.apikey.rawValue, value: publicKey))
        queryItemArray.append(URLQueryItem(name: URLKey.ts.rawValue, value: String(timestamp)))
        queryItemArray.append(URLQueryItem(name: URLKey.hash.rawValue, value: generateHash(ts: timestamp, publicKey: publicKey, privateKey: privateKey)))
        queryItemArray.append(URLQueryItem(name: URLKey.offset.rawValue, value: String(offset)))
        queryItemArray.append(URLQueryItem(name: URLKey.limit.rawValue, value: String(limit)))
        if !orderBy.isEmpty {
            queryItemArray.append(URLQueryItem(name: URLKey.orderBy.rawValue, value: orderBy))
        }
        if !startsWith.isEmpty {
            let startsWithKey = getStartsWithKey(itemType: itemType)
            if !startsWithKey.isEmpty {
                queryItemArray.append(URLQueryItem(name: startsWithKey, value: startsWith))
            }
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
    
    func getCharacters(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: CharacterDto.self,
                                  itemType: .character,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
    }
    
    func getComics(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: ComicDto.self,
                                  itemType: .comic,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
    }
    
    func getCreators(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: CreatorDto.self,
                                  itemType: .creator,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
    }
    
    func getEvents(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: EventDto.self,
                                  itemType: .event,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
    }
    
    func getSeries(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: SeriesDto.self,
                                  itemType: .series,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
    }
    
    func getStories(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String
    ) async throws -> [Item] {
        return try await getItems(dtoType: StoryDto.self,
                                  itemType: .story,
                                  prefix: prefix,
                                  id: id,
                                  offset: offset,
                                  limit: limit,
                                  orderBy: orderBy,
                                  startsWith: startsWith)
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

func getStartsWithKey(itemType: ItemType) -> String {
    switch itemType {
    case .character:
        return URLKey.nameStartsWith.rawValue
    case .comic:
        return URLKey.titleStartsWith.rawValue
    case .creator:
        return URLKey.nameStartsWith.rawValue
    case .event:
        return URLKey.nameStartsWith.rawValue
    case .series:
        return URLKey.titleStartsWith.rawValue
    case .story:
        return ""
    case .favorite:
        return ""
    }
}

enum OrderBy: String {
    case name
    case nameDesc = "-name"
    case firstName
    case firstNameDesc = "-firstName"
    case lastName
    case lastNameDesc = "-lastName"
    case title
    case titleDesc = "-title"
    case modified
    case modifiedDesc = "-modified"
    case onSaleDate = "onsaleDate"
    case onSaleDateDesc = "-onsaleDate"
    case startDate
    case startDateDesc = "-startDate"
    case startYear
    case startYearDesc = "-startYear"
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
