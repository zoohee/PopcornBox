//
//  SearchViewController.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class SearchViewController: UIViewController {
    
    var movieListView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    var searchController = UISearchController()
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    func configure() {
    }
}
