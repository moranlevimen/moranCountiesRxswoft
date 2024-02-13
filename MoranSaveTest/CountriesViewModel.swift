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
    var data: Observable<[Countries]> = Observable([])


    func fetchData() {
        if let url = URL(string: urlString) {
            NetworkManager().fetchDataFromURL(url: url) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let countries):
                    strongSelf.countries = countries
                    strongSelf.data.value = countries
      
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
    
    // Save country to UserDefaults
       func saveCountry(_ country: Countries) {
           var savedCountries = UserDefaults.standard.array(forKey: "SavedCountries") as? [[String: Any]] ?? []
           let countryData: [String: Any] = ["name": country.name?.common ?? "", "region": country.region ?? "", "subregion": country.subregion ?? ""]
           savedCountries.append(countryData)
           UserDefaults.standard.set(savedCountries, forKey: "SavedCountries")
       }
    
    // Retrieve saved countries from UserDefaults
       func retrieveSavedCountries() -> [Countries] {
           let savedCountriesData = UserDefaults.standard.array(forKey: "SavedCountries") as? [[String: Any]] ?? []
           var savedCountries: [Countries] = []
           for countryData in savedCountriesData {
               let country = Countries(name: Countries.NameDetails(common: countryData["name"] as? String ?? ""), region: countryData["region"] as? String, subregion: countryData["subregion"] as? String, flag: nil, saved: true)
               savedCountries.append(country)
           }
           return savedCountries
       }

    // Combine saved countries with fetched countries and handle scenarios where saved country may not appear in fetched list
     func refreshList() {
         let savedCountries = retrieveSavedCountries()
            // Fetch fresh list of countries
            fetchData()
            // Combine saved countries with fetched countries
            let combinedCountries = savedCountries + countries.filter { country in
                // Check if the country is not already saved
                !savedCountries.contains(where: { $0 == country })
            }
            // Update countries array with combined list
            countries = combinedCountries
     }

}
