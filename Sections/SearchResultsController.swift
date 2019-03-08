//
//  SearchResultsController.swift
//  Sections
//
//  Created by Brian Wawczak on 3/7/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
  private static let longNameSize = 6
    private static let shortNamesButtonIndex = 1
    private static let longNamesButtonindex = 2

    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names: [String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }
    //MARK: Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionsTableIdentifier)
        cell!.textLabel?.text = filteredNames[indexPath.row]
        return cell!
    }
    
    //MARK: UIsearchResultsUpdating Conformance
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredNames.removeAll(keepingCapacity: true)
            
            if !searchString.isEmpty {
                let filter: (String) -> Bool = { name in
                    //Filter out long or short names depending on which
                    //scope button is selectd.
                    let nameLength = name.count
                    if (buttonIndex == SearchResultsController.shortNamesButtonIndex && nameLength >= SearchResultsController.longNameSize) ||
                        (buttonIndex == SearchResultsController.longNamesButtonindex && nameLength < SearchResultsController.longNameSize) {
                        return false
                    }
                    
                    let range = name.range(of: searchString, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    
                    return range != nil
                    
                }
                
                for key in keys {
                    let namesForKey = names[key]!
                    let matches = namesForKey.filter(filter)
                    filteredNames += matches
                }
            }
        }
        tableView.reloadData()
    }


    
}
