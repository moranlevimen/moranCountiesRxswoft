//
//  CountriesViewModel.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//


import Foundation
import Combine

class CountriesViewModel {
    
    let urlString = "https://restcountries.com/v3.1/all"
    
    // Publisher for countries data
    private var dataSubject = PassthroughSubject<[Countries], Error>()
    var data: AnyPublisher<[Countries], Error> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        NetworkManager().fetchDataFromURL(url: url) { result in
            switch result {
            case .success(let countries):
                // Handle successful completion by sending countries through dataSubject
                self.dataSubject.send(countries)
            case .failure(let error):
                // Handle failure by printing the error
                print("Error fetching data:", error)
            }
        }
    }
        
    // Save country to UserDefaults
    func saveCountry(_ country: Countries) {
        var savedCountries = UserDefaults.standard.array(forKey: "SavedCountries") as? [[String: Any]] ?? []
        let countryData: [String: Any] = ["name": country.name?.common ?? "",
                                           "region": country.region ?? "",
                                           "subregion": country.subregion ?? ""]
        savedCountries.append(countryData)
        UserDefaults.standard.set(savedCountries, forKey: "SavedCountries")
    }
    
    // Retrieve saved countries from UserDefaults
    func retrieveSavedCountries() -> [Countries] {
        let savedCountriesData = UserDefaults.standard.array(forKey: "SavedCountries") as? [[String: Any]] ?? []
        var savedCountries: [Countries] = []
        for countryData in savedCountriesData {
            let country = Countries(name: Countries.NameDetails(common: countryData["name"] as? String ?? ""),
                                    region: countryData["region"] as? String,
                                    subregion: countryData["subregion"] as? String,
                                    flag: nil,
                                    saved: true)
            savedCountries.append(country)
        }
        return savedCountries
    }
    
    // Combine saved countries with fetched countries and handle scenarios where saved country may not appear in fetched list
    func refreshList() {
        let savedCountries = retrieveSavedCountries()
        fetchData() // Fetch fresh list of countries
        
        data
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] fetchedCountries in
                    let combinedCountries = savedCountries + fetchedCountries.filter { country in
                        !savedCountries.contains(where: { $0 == country })
                    }
                    self?.dataSubject.send(combinedCountries)
                  })
            .store(in: &cancellables)
    }
}
