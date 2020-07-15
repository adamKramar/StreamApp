//
//  Constants.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 25/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation

struct K {
    
    struct Text {
        static let okButton = "Ok"
        static let noConnection = "No connection"
        static let errorTitle = "Error"
    }
    
    struct Segues {
        static let movieDetail = "showMovieDetail"
    }
    
    struct List {
        static let listHeight = 120.0
        static let listHeightPad = 180.0
        static let movieCell = "MovieCell"
        static let movieEntity = "Movie"
    }
    
    struct Api {
        static let apiUrl = "https://api.themoviedb.org/3/movie/"
        static let apiKey = "?api_key=32f98a666718b31ee999e75219ec2be9"
        static let imgPath = "https://image.tmdb.org/t/p/w342"
    }
    
    struct Error {
        static let popularList = "Getting list of popular movies failed. Api is unreachable."
        static let posterImage = "Getting poster image failed. Api is unreachable."
        static let movieDetail = "Getting movie details failed. Api is unreachable."
        static let trailer = "Getting movie trailer failed. Api is unreachable."
        static let decodeData = "Unable to decode data."
        static let connection = "No network connection, appliacation will run in offline mode. You will be able to view stored content. You can attempt to download new data by pulling down on Movie Catalog page."
        static let watchTrailer = "Trailers are unavailable in offline mode."
        static let noTrailer = "Application was unable to find trailer for this movie."
        static let dbLoadFaild = "Application was unable to fetch data from local storage."
        static let videoKeyMissing = "Appliacation was not able to get identifier for requested video."
    }
}
