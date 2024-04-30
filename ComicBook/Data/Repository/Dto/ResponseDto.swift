//
//  ResponseDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

struct ResponseDto<T: Codable>: Codable{
    let code: Int
    let status: String
    let data: DataDto<T>
}
