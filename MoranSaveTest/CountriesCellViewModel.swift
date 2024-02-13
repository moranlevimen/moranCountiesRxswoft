//
//  CountriesCellViewModel.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation

class CountriesCellViewModel: Hashable {
        
        let countryModel: Countries
        
        init(_ countryModel: Countries) {
            self.countryModel = countryModel
        }
        
        func getName() -> String? {
            return countryModel.name?.common
        }
        
        func getRegion() -> String? {
            return countryModel.region
        }
        
        func getSubregion() -> String? {
            return countryModel.subregion
        }
        
        func getFlagURL() -> URL? {
            if let flagString = countryModel.flag {
                return URL(string: flagString)
            }
            return nil
        }
        
        func isSaved() -> Bool? {
            return countryModel.saved
        }
        
        static func == (lhs: CountriesCellViewModel, rhs: CountriesCellViewModel) -> Bool {
            return lhs.countryModel.name?.common == rhs.countryModel.name?.common
        }
        
        func hash(into hasher: inout Hasher) {
            if let name = countryModel.name?.common {
                hasher.combine(name)
            }
        }
    
    
}
