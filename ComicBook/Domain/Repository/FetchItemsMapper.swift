//
//  FetchItemsMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/15/24.
//

import Foundation

func getFetchItems(itemType: ItemType, repository: ComicBookRepository) -> ((String, Int, Int, Int, String, String, Bool) async throws -> [Item]) {
    switch itemType {
    case ItemType.comic:
        return repository.getComics
    case ItemType.character:
        return repository.getCharacters
    case ItemType.creator:
        return repository.getCreators
    case ItemType.event:
        return repository.getEvents
    case ItemType.series:
        return repository.getSeries
    case ItemType.story:
        return repository.getStories
    }
}

func getItemTypesForDetail(itemType: ItemType) -> [ItemType] {
    switch itemType {
    case ItemType.character:
        return [.comic, .series, .event, .story]
    case ItemType.comic:
        return [.character, .creator, .event, .story]
    case ItemType.creator:
        return [.comic, .series, .event, .story]
    case ItemType.event:
        return [.comic, .character, .creator, .series, .story]
    case ItemType.series:
        return [.comic, .character, .creator, .event, .story]
    case ItemType.story:
        return [.comic, .character, .creator, .event, .series]
    }
}

func getItemTypesForHome() -> [ItemType] {
    return [.comic, .character, .series, .creator, .event, .story]
}

func getDefaultOrderBy(itemType: ItemType) -> OrderBy {
    switch itemType {
    case ItemType.character:
        return .name
    case ItemType.comic:
        return .title
    case ItemType.creator:
        return .lastName
    case ItemType.event:
        return .name
    case ItemType.series:
        return .title
    case ItemType.story:
        return .modifiedDesc
    }
}

func getOrderByValues(itemType: ItemType) -> [OrderBy] {
    switch itemType {
    case ItemType.character:
        return [.name, .modifiedDesc]
    case ItemType.comic:
        return [.title, .onSaleDate, .onSaleDateDesc, .modifiedDesc]
    case ItemType.creator:
        return [.lastName, .firstName, .modifiedDesc]
    case ItemType.event:
        return [.name, .startDate, .startDateDesc, .modifiedDesc]
    case ItemType.series:
        return [.title, .startYear, .startYearDesc, .modifiedDesc]
    case ItemType.story:
        return [.modifiedDesc]
    }
}

func getOrderByName(orderBy: OrderBy) -> String {
    switch orderBy {
    case .name:
        return "Name"
    case .nameDesc:
        return "Name: Reverse"
    case .title:
        return "Title"
    case .titleDesc:
        return "Title: Reverse"
    case .lastName:
        return "Last Name"
    case .lastNameDesc:
        return "Last Name: Reverse"
    case .firstName:
        return "First Name"
    case .firstNameDesc:
        return "First Name: Reverse"
    case .onSaleDate:
        return "On Sale Date"
    case .onSaleDateDesc:
        return "On Sale Date: Most Recent"
    case .startDate:
        return "Start Date"
    case .startDateDesc:
        return "Start Date: Most Recent"
    case .startYear:
        return "Start Year"
    case .startYearDesc:
        return "Start Year: Most Recent"
    case .modified:
        return "Modified Date"
    case .modifiedDesc:
        return "Modified Date: Most Recent"
    }
}
