//
//  APIService.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    var boxOfficeData: BoxOffice?
    var KMDBData: MovieDetail?
    
    let targetDt: String = {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday ?? Date())
    }()
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        getBoxOfficeData { result in
            switch result {
            case .success(let boxOfficeResult):
                var resultMovies: [Movie] = []
                let movies = boxOfficeResult.map { dailyBoxOffice in
                    Movie(dailyBoxOffice: dailyBoxOffice)
                }
                // 영화 배열을 돌면서 fetchKMDBData 함수를 호출하여 thumbnail 채우기
                let dispatchGroup = DispatchGroup()
                
                for index in movies.indices {
                    dispatchGroup.enter()
                    
                    var movie = movies[index]
                    self.getMovieDetailData(title: movie.title) { result in
                        switch result {
                        case .success(let movie):
                            resultMovies.append(movie)
                            
                        case .failure(let error):
                            completion(.failure(error))
                            break
                        }

                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    // 모든 fetchKMDBData 호출이 완료된 후에 completion을 호출하여 movies 배열 반환
                    completion(.success(resultMovies))
                }
                
            case .failure(let error):
                print("Error fetching movie data: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getBoxOfficeData(completion: @escaping(Result<[DailyBoxOfficeList], Error>) -> Void) {
        let key = "528b59e923eabc9d762750774390567a"
        let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(key)&targetDt=\(targetDt)"
        
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let JSONdata = data else {
                    completion(.failure(NSError(domain: "No data returned", code: 0)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(BoxOffice.self, from: JSONdata)
                    completion(.success(decodedData.boxOfficeResult.dailyBoxOfficeList))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func getMovieDetailData(title: String, completion: @escaping(Result<Movie, Error>) -> Void) {
        
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let key = "8CAAU1M9N91D42GP55PD"
        let movieURL = "https://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?collection=kmdb_new2&detail=Y&title=\(encodedTitle)&ServiceKey=\(key)"
        
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                
                guard let JSONdata = data else {
                    completion(.failure(NSError(domain: "No data returned", code: 0)))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let movieDetail = try decoder.decode(MovieDetail.self, from: JSONdata)
                    
                    //                    guard let movieData = movieDetail else {
                    //                        print("No movie data found")
                    //                        return
                    //                    }
                    
                    let movie = self.updateMovieModel(title: title, movieDetail: movieDetail)
                    completion(.success(movie))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func updateMovieModel(title: String, movieDetail: MovieDetail) -> Movie {
        
        var movie = Movie()
        let movieData = movieDetail.data[0].result[0]
        
        movie.title = title
        
        for actor in movieData.actors.actor {
            movie.actor += actor.actorNm + ", "
        }
        
        for director in movieData.directors.director {
            movie.director += director.directorNm + ", "
        }
        
        movie.rating = Double(movieData.ratings.rating[0].ratingGrade) ?? 0.0
        movie.thumbnail = movieData.posters
        
        return movie
    }
    
}
