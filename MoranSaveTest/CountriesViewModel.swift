//
//  CountriesViewModel.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//


import Foundation

class CountriesViewModel {
    
    let urlString = "https://restcountries.com/v3.1/all"
    var countries: [Countries] = [] // This will hold the fetched countries data
    var countries: [Country] = []
    var data: Observable<[countries]> = Observable()

    func fetchData() {
        if let url = URL(string: urlString) {
            NetworkManager().fetchDataFromURL(url: url) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let countries):
                    strongSelf.countries = countries
                    strongSelf.data.value = countries
                    
                    // Notify observers here
                case .failure(let error):
                    // Handle error
                    print("Error fetching data:", error)
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
    }
}
