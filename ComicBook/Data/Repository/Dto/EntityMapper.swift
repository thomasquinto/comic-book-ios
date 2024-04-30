//
//  EntityMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

protocol EntityMapper: Codable, Identifiable {
    func toEntity() -> Entity
}
