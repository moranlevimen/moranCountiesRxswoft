//
//  Countries.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation

struct Countries: Codable, Equatable {
    
    let name: NameDetails?
    let region: String?
    let subregion: String?
    let flag: String?
    var saved: Bool?

    struct NameDetails: Codable, Equatable {
        let common: String
    }

    static func == (lhs: Countries, rhs: Countries) -> Bool {
        // Implement your equality logic here
        return lhs.name == rhs.name && lhs.region == rhs.region && lhs.subregion == rhs.subregion
    }
}
