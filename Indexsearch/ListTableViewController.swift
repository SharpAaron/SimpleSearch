//
//  ListTableViewController.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/20/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//
import RealmSwift
import UIKit
// global variables yay
var searchesWeWantToKeep = [String]()

class ListTableViewController: UITableViewController, UISearchBarDelegate {
    
    let realm = Realm()
    
    @IBOutlet weak var tableViews: UITableView!

    var searchViewController: YSLSearchViewController?
    
        var savedSearches: Results<SearchTerms>! {
            didSet {
                tableViews?.reloadData()
            }
        
        }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func reload() {
        savedSearches = realm.objects(SearchTerms).sorted("searchTerm", ascending: false)
        tableView.reloadData()
        }
    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()
        let settings = YSLSearchViewControllerSettings()
        settings.enableSearchToLink = true
        searchViewController = YSLSearchViewController(settings: settings);
        searchViewController!.delegate = self
        searchBar.delegate = self
        reload()
        //fetch realm searches here
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedSearches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let savedSearch = savedSearches[row] as SearchTerms
        cell.textLabel?.text = savedSearch.searchTerm
        return cell
    }
    

}

extension ListTableViewController: YSLSearchViewControllerDelegate {
    
    func searchViewController(searchViewController: YSLSearchViewController!, actionForQueryString queryString: String!) -> YSLQueryAction {
        println("actionForQueryString ---> \(queryString)")
        return YSLQueryAction.Search
    }
    
    func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func searchViewController(searchViewController: YSLSearchViewController!, didSearchToLink result: YSLSearchToLinkResult!) {
        
        println("did search to link query string --> \(searchViewController.queryString)")
        println("did search to link short url --> \(result.shortURL)")
        
    }

    func shouldSearchViewController(searchViewController: YSLSearchViewController!, previewSearchToLinkForSearchResultType searchResultType: String!) -> Bool {
        println("previewSearchToLink --->  \(searchResultType)")
        return true
    }

    func shouldSearchViewController(searchViewController: YSLSearchViewController!, loadWebResult result: YSLSearchWebResult!) -> Bool {
        println("loadWebResult ---> \(searchViewController.selectedResultType)")
        return false
    }
    
    
    
}

extension ListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchViewController?.queryString = searchBar.text
        searchViewController?.setSearchResultTypes([YSLSearchResultTypeWeb])
        
        self.presentViewController(searchViewController!, animated: true, completion: nil);
        var searchesWeWantToKeep = searchBar.text
        // Created a SearchTerms class
        let searchContent = SearchTerms()
        searchContent.searchTerm = searchBar.text
        let searchObject = searchContent.searchTerm
        let realm = Realm()
        realm.write {
            realm.add(searchContent)
            
        }
        reload()
        let searchstring = searchContent.searchTerm
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("go back ")
    }
}
