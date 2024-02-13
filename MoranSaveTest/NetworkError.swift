//
//  NetworkError.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case parseFailed
    case unknownError
}
