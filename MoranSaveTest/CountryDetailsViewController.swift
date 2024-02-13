//
//  CountryDetailsViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    var country: Countries? // This will hold the selected country's data
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Display country details
        if let country = country {
            regionLabel.text = "Region: \(country.region ?? "")"
            subregionLabel.text = "Subregion: \(country.subregion ?? "")"
            
            if let flagURLString = country.flag, let flagURL = URL(string: flagURLString) {
                loadImageFromURL(flagURL)
            }
        }
    }

    func loadImageFromURL(_ url: URL) {
        // Perform image download asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                // Handle error
                print("Error downloading image:", error)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                // Update UI on the main queue
                DispatchQueue.main.async {
                    // Assign the downloaded image to the flag image view
                    self.flagImageView.image = image
                }
            } else {
                // Handle nil data or failed image creation
                print("Failed to create image from data")
            }
        }.resume()
    }
}

