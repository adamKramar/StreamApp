//
//  Movie.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 24/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation

struct Movies: Decodable {
    let results: [MovieData]
}

struct MovieData: Decodable {
    let title: String
    let poster_path: String
    let backdrop_path: String
    let id: Int
    let release_date: String
    let overview: String
    let popularity: Double
}

struct Trailers: Decodable {
    let results: [TrailerData]
}

struct TrailerData: Decodable {
    let key: String
}

struct MovieDetailData: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let name: String
}
