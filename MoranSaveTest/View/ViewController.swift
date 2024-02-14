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
                // Merge saved countries with fetched countries and update the array
                let mergedCountries = self?.mergeSavedAndFetchedCountries(savedCountries: savedCountries, fetchedCountries: countries) ?? []
                self?.countries = mergedCountries
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        countriesViewModel?.fetchData()
        
        let nib = UINib(nibName: "CountiresCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "countiresTableViewCell")
        title = "search"
    }

    // Function to merge saved countries with fetched countries
    func mergeSavedAndFetchedCountries(savedCountries: [Countries], fetchedCountries: [Countries]) -> [Countries] {
        var mergedCountries = [Countries]()
        
        // Add saved countries at the top of the list and mark them as saved
        for savedCountry in savedCountries {
            if let index = fetchedCountries.firstIndex(where: { $0.name == savedCountry.name }) {
                // Highlight saved country
                var country = fetchedCountries[index]
                country.saved = true
                mergedCountries.append(country)
            }
        }
        
        // Add fetched countries that are not already saved
        for country in fetchedCountries {
            if !savedCountries.contains(where: { $0.name == country.name }) {
                mergedCountries.append(country)
            }
        }
        
        return mergedCountries
    }

}

private var cancellables: Set<AnyCancellable> = []



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
            let countryName = searchCountry[indexPath.row]
            cell.countyLabel.text = countryName
            
            // Find the corresponding flag for the searched country
            if let country = countries.first(where: { $0.name?.common == countryName }), let flag = country.flag {
                cell.flagImage.text = flag
            } else {
                cell.flagImage.isHidden = true
                cell.defaultFlagImageview.image = UIImage(named: "UnknownFlag")
            }
        } else {
            let country = countries[indexPath.row]
            cell.countyLabel.text = country.name?.common
            
            if let flag = country.flag {
                cell.flagImage.text = flag
            } else {
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
          
          let selectedCountry: Countries
          
          if searching {
              if let countryName = searchCountry[safe: indexPath.row],
                 let country = countries.first(where: { $0.name?.common == countryName }) {
                  selectedCountry = country
              } else {
                  // Handle the scenario where the selected country is not found
                  return
              }
          } else {
              if let country = countries[safe: indexPath.row] {
                  selectedCountry = country
              } else {
                  // Handle the scenario where the selected country is not found
                  return
              }
          }
          
          performSegue(withIdentifier: "toDetailsVC", sender: selectedCountry)
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
               searchCountry = []
               searching = false
           } else {
               searchCountry = countries.filter {
                   $0.name?.common.prefix(searchText.count) ?? "" == searchText
               }.compactMap { $0.name?.common }
               searching = true
           }
           tableView.reloadData()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
