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
        countyLabel.text = vm.getName()
    }
    
}

