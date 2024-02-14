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
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display country details
        if let country = country {
            regionLabel.text = "Region: \(country.region ?? "")"
            subregionLabel.text = "Subregion: \(country.subregion ?? "")"
            
            if let flagURL = country.flag, let url = URL(string: flagURL) {
                // RxSwift
                URLSession.shared.rx.data(request: URLRequest(url: url))
                    .map { UIImage(data: $0) }
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] image in
                        self?.flagImageView.image = image
                    })
                    .disposed(by: DisposeBag())
                
                // Combine
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { data, _ in UIImage(data: data) }
                    .replaceError(with: nil)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] image in
                        self?.flagImageView.image = image
                    }
                    .store(in: &cancellables)
            } else {
                // Handle case where flag URL is nil or invalid
                self.flagImageView.image = UIImage(named: "UnknownFlag")
            }
        }
        
        // Save country data
        if let country = country {
            countriesViewModel.saveCountry(country)
        }
    }
}

