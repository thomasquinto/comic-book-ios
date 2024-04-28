//
//  ComicDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicDto: Codable, Identifiable{
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    /*
     let modified: Date?
     
     enum CodingKeys: String, CodingKey {
        case id, title, description, thumbnail, modified
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        thumbnail = try container.decode(ThumbnailDto.self, forKey: .thumbnail)

        let dateString = try container.decode(String.self, forKey: .modified)
        if let date = DateFormatter.iso8601Full.date(from: dateString) {
            modified = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .modified, in: container, debugDescription: "Date string does not match expected format")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        if let modified {
            try container.encode(DateFormatter.iso8601Full.string(from: modified), forKey: .modified)
        }
    }
     */
}

struct ThumbnailDto: Codable{
    let path: String
    // extension is JSON name
    let suffix: String
    
    enum CodingKeys: String, CodingKey{
        case path
        case suffix = "extension"
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
