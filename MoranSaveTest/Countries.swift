//
//  Countries.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation
struct Countries: Codable {
    let name: NameDetails?
    let region: String?
    let subregion: String?
    let flag: String?
    var saved: Bool?
    

    struct NameDetails: Codable {
        let common: String
    }
}

struct NameDetails: Codable {
    let common: String?
    let official: String?
    
}
