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
    
    var movieData: [MovieData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        configureNavigationBar()
        createViews()
        setConstraints()
        
        let dispatchGroup = DispatchGroup()
        
        APIService.apiManager.getMovieData() { result in
            
            for title in result {
                dispatchGroup.enter() // 진입
                
                APIService.apiManager.getMovieDetailData(titles: [title]) {
                    self.movieData.append(APIService.apiManager.updateMovieModel())
                    
                    dispatchGroup.leave() // 완료
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // 모든 작업이 완료된 후 실행되는 코드
                //                print("count: \(self.movieData.count)")
                //                print("\(self.movieData)")
                self.movieListView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        movieListView.reloadData()
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
        navigationController?.view.addSubview(movieListView)
    }
    
    func setConstraints() {
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
        
        cell.titleLabel.text = "title: \(String(describing: APIService.apiManager.boxOfficeData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm ?? ""))"
        
        print("\(indexPath.row)")
        print(movieData)
        
//                cell.actorLabel.text = "actor: \(movieData[indexPath.row].actor)"
        //        cell.directorLabel.text = "director: \(movieData[indexPath.row].director)"
        
        return cell
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
