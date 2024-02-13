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
    @IBOutlet weak var flagImage: UIImageView!
    
    func cellConfig(){
        
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
