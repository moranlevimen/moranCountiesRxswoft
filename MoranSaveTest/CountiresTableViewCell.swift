//
//  CountiresTableViewCell.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation
import UIKit

class CountiresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var flagImage: UILabel!
    @IBOutlet weak var defaultFlagImageview: UIImageView!
    
    func cellConfig(vm: CountriesCellViewModel){
        if vm != nil {
            //
        } else {
            print("error index out of range")
        }
        
        countyLabel.text = vm.getName()
       // flagImage.image = loadImageFromURL(vm.getFlagURL()!)
        
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
                    // Assign the downloaded image to your UIImageView
                  //  self.flagImage.image = image
                }
            } else {
                // Handle nil data or failed image creation
                print("Failed to create image from data")
            }
        }.resume()
    }
}

// Extension to UIImageView to load image from URL asynchronously
extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
