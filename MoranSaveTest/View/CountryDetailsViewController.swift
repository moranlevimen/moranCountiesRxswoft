//
//  CountryDetailsViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class CountryDetailsViewController: UIViewController {
    
    var country: Countries? // This will hold the selected country's data
    var countriesViewModel = CountriesViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var flagImage: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Display country details + saving
        if let country = country {
            countriesViewModel.saveCountry(country)

            regionLabel.text = "Region: \(country.region ?? "")"
            subregionLabel.text = "Subregion: \(country.subregion ?? "")"
            flagImage.text = country.flag ?? ""
            
        }
    }
}

