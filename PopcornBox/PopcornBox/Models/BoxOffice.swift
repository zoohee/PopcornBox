//
//  BoxOffice.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {
    let rank: String
    let movieNm: String
}
