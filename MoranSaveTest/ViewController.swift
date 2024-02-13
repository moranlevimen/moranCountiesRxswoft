//
//  ViewController.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource {
   
    var countriesViewModel: CountriesViewModel?
//    var data: Observable<[String: [ProductsCellViewModel]]> = Observable([:])
    var searchCountry = [String]()
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesViewModel = CountriesViewModel()

        countriesViewModel?.fetchData()
                
        let nib = UINib(nibName: "CountiresCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "countiresTableViewCell")
        binding()
        title = "search"
//        navigationItem.searchController = searchBar
    }

    private func binding() {
        countriesViewModel?.data.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchCountry.count
        }else {
            return countriesViewModel?.countries.count ?? 8

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countiresTableViewCell", for: indexPath) as! CountiresTableViewCell
        
        if searching {
            cell.countyLabel.text = searchCountry[indexPath.row]
        } else {
            cell.countyLabel.text = countriesViewModel?.countries[indexPath.row].name?.common
//            if countriesViewModel?.countries[indexPath.row].flag != nil {
//                //        cell.flagImage.image = UIImage(data: (countriesViewModel?.countries[indexPath.row].flag)!)
//                //todo flag
//            }
//            }else {
//                cell.flagImage.image =  UIImage(systemName: "UnknownFlag")
//            }
            
        }
        return cell
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
