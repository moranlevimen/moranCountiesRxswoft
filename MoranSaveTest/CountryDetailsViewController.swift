//
//  CountryDetailsViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    var country: Countries? // This will hold the selected country's data
    var countriesViewModel = CountriesViewModel()
    
    @IBOutlet weak var flagImageView: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesViewModel = CountriesViewModel()
        
        // Display country details
        if let country = country {
            regionLabel.text = "Region: \(country.region ?? "")"
            subregionLabel.text = "Subregion: \(country.subregion ?? "")"
            flagImageView.text = country.flag ?? ""
            
        }
        
        countriesViewModel.saveCountry(country!)
        
    }
    

    
}

