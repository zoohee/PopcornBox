//
//  APIService.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import Foundation

class APIService {
    static let apiManager = APIService()
    
    var boxOfficeData: BoxOffice?
    var KMDBData: MovieDetail?
    
    func getMovieData(completion: @escaping([String]) -> Void) {
        let date = "20230523"
        let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=528b59e923eabc9d762750774390567a&targetDt=" + date
        var movieName: [String] = []
        
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let JSONdata = data else { return }
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(BoxOffice.self, from: JSONdata)
                    
                    self.boxOfficeData = decodedData
                    
                    movieName = self.boxOfficeData?.boxOfficeResult.dailyBoxOfficeList.map{$0.movieNm} ?? [""]
                    // 함수 실행 완료 되면 movieName 넘겨줌
                    completion(movieName)
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func getMovieDetailData(titles: [String], completion: @escaping() -> Void) {
        for title in titles {
            guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            let movieURL = "https://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?collection=kmdb_new2&detail=Y&title=\(encodedTitle)&ServiceKey=8CAAU1M9N91D42GP55PD"
            
            if let url = URL(string: movieURL) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    guard let JSONdata = data else { return }
                    
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieDetail.self, from: JSONdata)
                        self.KMDBData = decodedData
                        //                        self.KMDBData.append(decodedData)
                    } catch {
                        print(error)
                    }
                    completion()
                }
                task.resume()
            }
        }
    }
    
    // 로직: getMovieDetailData -> updateMovieModel 반복 0, 1, 2, ...
    func updateMovieModel() -> MovieData {

        var movieData = MovieData()
        
        if let movie = self.KMDBData?.data[0].result[0] {
            
            movieData.title = movie.title
            
            for actor in movie.actors.actor {
                movieData.actor += actor.actorNm + ", "
            }
            
            for director in movie.directors.director {
                movieData.director += director.directorNm + ", "
            }
        }
        
        return movieData
    }
    
}
