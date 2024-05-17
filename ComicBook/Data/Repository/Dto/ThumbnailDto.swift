//
//  ThumbnailDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

struct ThumbnailDto: Codable {
    let path: String
    // extension is JSON name
    let suffix: String
    
    static let missingImageUrl = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
    
    enum CodingKeys: String, CodingKey{
        case path
        case suffix = "extension"
    }
    
    func getThumbnailUrl() -> String {
        return "\(path).\(suffix)".replacing("http://", with: "https://")
    }
        
}
