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
    var thumbnailImage: String = ""
    var description: String = ""
    var review: String = ""
    var rank: Int = 0
    var movieCd: String = ""
    var selectedThumbnail: String? {
            let thumbnailLinks = thumbnailImage.components(separatedBy: "|")
            return thumbnailLinks[0]
        }
}

extension Movie {
    init(dailyBoxOffice: DailyBoxOfficeList) {
        self.title = dailyBoxOffice.movieNm
        self.rank = Int(dailyBoxOffice.rank) ?? 0
        self.movieCd = dailyBoxOffice.movieCd
    }
}

