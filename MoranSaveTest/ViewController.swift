//
//  ViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var countriesViewModel = CountriesViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesViewModel = CountriesViewModel()
        let nib = UINib(nibName: "cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CountiresTableViewCell")
        
        countriesViewModel.fetchData()
        binding()
    }

    private func binding() {
   //      Update the table view when data changes in the view model
        countriesViewModel.data.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CountiresTableViewCell", for: indexPath) as! CountiresTableViewCell
        //let country = countriesViewModel.countries[indexPath.row]
        // Configure cell with country data
       // cell.configure(with: country)
        return cell
    }
}
