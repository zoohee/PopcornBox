//
//  MovieData.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

struct Movie {
    var title: String = ""
    var director: String = ""
    var actor: String = ""
    var rating: Double = 0.0
    var discription: String = "영화다"
    var thumbnail: String = ""
    var mainThumbnail: String? {
        let thumbnailLinks = thumbnail.components(separatedBy: "|")
        return thumbnailLinks.randomElement()
    }
    var review: String = ""
}

extension Movie {
    init(dailyBoxOffice: DailyBoxOfficeList) {
        self.title = dailyBoxOffice.movieNm
    }
}
