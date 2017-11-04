//
//  GCSearchResultsController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/1/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCSearchResultsController class defines a view controller containing a search results interface.

class GCSearchResultsController: UITableViewController {
    
    // MARK: Properties
    
    /// The object that acts as the delegate of the search results view controller.
    
    var delegate: GCSearchResultsDelegate?
    
    fileprivate let displayMode: GCSearchResultsDisplayMode
    
    fileprivate var searchResults = [GCSearchResult]()
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        
        return nil
    }
    
    /// Initializes and returns a newly allocated search results controller object.
    ///
    /// - Parameter displayMode: The display mode for the search results.
    /// - Returns: An initialized search results controller object.
    
    init(displayMode: GCSearchResultsDisplayMode) {
        
        self.displayMode = displayMode
        
        super.init(style: .plain)
    }
}

// MARK: - View

extension GCSearchResultsController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureTableView()
    }
}

// MARK: - Updating

extension GCSearchResultsController {
    
    func update(withSearchResults searchResults: [GCSearchResult]) {
        
        self.searchResults = searchResults
        
        if !self.searchResults.isEmpty {
            
            let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.5)
            
            self.tableView.scrollRectToVisible(rect, animated: false)
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Table View

extension GCSearchResultsController {
    
    fileprivate func configureTableView() {
        
        self.tableView.keyboardDismissMode = .onDrag
        
        switch self.displayMode {
            
            case .withAccessoryTitles:
                self.tableView.register(GCTableViewCell.self, forCellReuseIdentifier: GCTableViewCell.identifier)
            
            case .withoutAccessoryTitles:
                self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        }
    }
}

// MARK: - UITableViewDelegate

extension GCSearchResultsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchResult = self.searchResults[indexPath.row]
        
        self.delegate?.searchResultsController(self, didSelectSearchResult: searchResult)
    }
}

// MARK: - UITableViewDataSource

extension GCSearchResultsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = self.searchResults[indexPath.row]
        
        switch self.displayMode {
            
            case .withAccessoryTitles:
                let cell = tableView.dequeueReusableCell(withIdentifier: GCTableViewCell.identifier, for: indexPath) as! GCTableViewCell
                
                cell.titleLabel.text = searchResult.displayTitle
                cell.accessoryLabel.text = searchResult.accessoryTitle
                
                return cell
            
            case .withoutAccessoryTitles:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                
                cell.textLabel?.text = searchResult.displayTitle
                
                return cell
        }
    }
}