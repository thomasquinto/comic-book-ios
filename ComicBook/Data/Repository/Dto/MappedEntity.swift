//
//  EntityMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

protocol MappedEntity: Codable, Identifiable {
    func toEntity() -> Entity
}
