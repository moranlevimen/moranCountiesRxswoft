//
//  NetworkManager.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation
struct NetworkManager {
    func fetchDataFromURL(url: URL, completion: @escaping(Result<[Countries], Error>) -> Void) {
         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                 completion(.failure(NetworkError.invalidData))
                 return
             }
             
             if let data = data {
                 DispatchQueue.main.async {
                     do {
                         let decodedData = try JSONDecoder().decode([Countries].self, from: data)
                         completion(.success(decodedData))
                     } catch {
                         completion(.failure(NetworkError.parseFailed))
                     }
                 }
             } else {
                 completion(.failure(NetworkError.parseFailed))
             }
         }
         task.resume()
     }
 }

