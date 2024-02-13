//
//  ViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var countriesViewModel: CountriesViewModel?
    var searchCountry = [String]()
    var searching = false
    var countries: [Countries] = [] // This will hold the list of countries to display
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesViewModel = CountriesViewModel()
        
        let savedCountries = countriesViewModel?.retrieveSavedCountries() ?? []
        countries.append(contentsOf: savedCountries)
        
        countriesViewModel?.fetchData()
        
        let nib = UINib(nibName: "CountiresCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "countiresTableViewCell")
        binding()
        title = "search"
    }
    
    private func binding() {
        countriesViewModel?.data.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        }else {
            return countriesViewModel?.countries.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countiresTableViewCell", for: indexPath) as! CountiresTableViewCell
        
        if searching {
            cell.countyLabel.text = searchCountry[indexPath.row]
        } else {
            cell.countyLabel.text = countriesViewModel?.countries[indexPath.row].name?.common
            if countriesViewModel?.countries[indexPath.row].flag != nil {
                cell.flagImage.text = countriesViewModel?.countries[indexPath.row].flag
            }
            else {
                cell.flagImage.isHidden = true
                cell.defaultFlagImageview.image = UIImage(named: "UnknownFlag")
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            if let destinationVC = segue.destination as? CountryDetailsViewController,
               let selectedCountry = sender as? Countries {
                destinationVC.country = selectedCountry
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedCountry = countriesViewModel?.countries[indexPath.row] else {
                return
            }
        // Use performSegue(withIdentifier:sender:) to trigger the segue
        performSegue(withIdentifier: "toDetailsVC", sender: selectedCountry)
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry = countriesViewModel?.countries.filter {
            $0.name?.common.prefix(searchText.count) ?? "m" == searchText
        }.compactMap { $0.name?.common } ?? []
        searching = true
        tableView.reloadData()
    }
    
}
