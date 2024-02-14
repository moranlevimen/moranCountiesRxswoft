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
    private var cancellables = Set<AnyCancellable>()
    private var countries: [Countries] = [] // New property to hold the fetched countries
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesViewModel = CountriesViewModel()
        
        let savedCountries = countriesViewModel?.retrieveSavedCountries() ?? []
        
        countriesViewModel?.data
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Handle error
                    print("Error:", error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] countries in
                // Update the countries array of the view model
                self?.countries = countries
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        countriesViewModel?.fetchData()
        
        let nib = UINib(nibName: "CountiresCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "countiresTableViewCell")
        title = "search"
    }
}
    
    private var cancellables: Set<AnyCancellable> = []

 func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            if let destinationVC = segue.destination as? CountryDetailsViewController,
               let selectedCountry = sender as? Countries {
                destinationVC.country = selectedCountry
            }
        }
    }

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        } else {
            return countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countiresTableViewCell", for: indexPath) as! CountiresTableViewCell
        
        if searching {
            cell.countyLabel.text = searchCountry[indexPath.row]
        } else {
            cell.countyLabel.text = countries[indexPath.row].name?.common
            if countries[indexPath.row].flag != nil {
                cell.flagImage.text = countries[indexPath.row].flag
            } else {
                cell.flagImage.isHidden = true
                cell.defaultFlagImageview.image = UIImage(named: "UnknownFlag")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        // Optional binding to unwrap countries
//           if let selectedCountry = countries[safe: indexPath.row] {
//               performSegue(withIdentifier: "toDetailsVC", sender: selectedCountry)
//        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry = countries.filter {
            $0.name?.common.prefix(searchText.count) ?? "m" == searchText
        }.compactMap { $0.name?.common }
        searching = true
        tableView.reloadData()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
