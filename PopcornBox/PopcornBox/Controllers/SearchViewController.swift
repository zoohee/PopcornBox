//
//  SearchViewController.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    var movieListView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUI()
        setAutoLayOut()
    }
    
    func configure() {
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        // UITableView 생성 및 설정
        movieListView.dataSource = self
        movieListView.delegate = self
        
        movieListView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    func setUI() {
        view.backgroundColor = .white
        title = "검색"
    }
    
    func setAutoLayOut() {
        
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: guide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(movieListView)
        NSLayoutConstraint.activate([
            movieListView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            movieListView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            movieListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            movieListView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        cell.contentView.addSubview(paddingView)
        cell.contentView.sendSubviewToBack(paddingView)
//        cell.configure(with: movies[indexPath.row])
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
    }
}
