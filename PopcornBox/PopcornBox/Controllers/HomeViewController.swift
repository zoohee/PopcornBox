//
//  HomeViewController.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class HomeViewController: UIViewController {
    
    var movieListView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var movieData: [Movie] = []
    
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popcorn")?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        configureNavigationBar()
        createViews()
        setConstraints()
        APIService.shared.fetchMovies { result in
            switch result {
            case .success(let movies):
                self.movieData = movies
                DispatchQueue.main.async {
                    self.movieListView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure() {
        movieListView.delegate = self
        movieListView.dataSource = self
        
        registerCells()
    }
    
    private func registerCells() {
        self.movieListView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "현재 상영작"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func createViews() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(logoImage)
        
        navigationController?.view.addSubview(movieListView)
    }
    
    func setConstraints() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        NSLayoutConstraint.activate([
                logoImage.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -10),
                logoImage.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -10),
                logoImage.heightAnchor.constraint(equalToConstant: 70),
                logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor)
                ])
        
        guard let navigationControllerView = navigationController?.view else {
            return
        }
        
        let guide = navigationControllerView.safeAreaLayoutGuide
        
        if let bottomAnchor = navigationController?.navigationBar.layoutMarginsGuide.bottomAnchor {
            movieListView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        } else {
            movieListView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        }
        
        movieListView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        movieListView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        movieListView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        tableView.separatorStyle = .none // 선 없애기
        
        // if문 안 해주면 movieData에 값이 없어서 초기에 index out of range
        // director와 actor에서 마지막 ", " 제거
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.movieData.isEmpty {
                cell.titleLabel.text = self.movieData[indexPath.row].title
                
                let actor = self.movieData[indexPath.row].actor
                if actor != ", " {
                    cell.actorLabel.text = "Actor: " + String(actor.prefix(actor.count - 2))
                }
                
                let director = self.movieData[indexPath.row].director
                if director != ", " {
                    cell.directorLabel.text = "Director: " + String(director.prefix(director.count - 2))
                }

                self.loadImage(from: self.movieData[indexPath.row].mainThumbnail ?? "",
                          into: cell.movieImage)
            }
        }
        
        return cell
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // 원하는 높이 값으로 대체
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modalVC = CustomModalViewController()
        // 모달 스타일 설정
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        // 배경 터치로 모달 닫기 설정
        modalVC.isModalInPresentation = true
        modalVC.didDismissModal = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        present(modalVC, animated: false, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
