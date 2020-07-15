//
//  TestDataStructs.swift
//  StreamAppAdamKramarTests
//
//  Created by Adam Kramar on 15/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation

struct TestMovieData {
    
    static let title = "movie_title"
    static let id = Int64(1)
    static let image = Data(count: 10)
    static let poster_path = "poster_path"
    static let backdrop_path = "backdrop_path"
    static let release_date = "1995-09-04"
    static let release_date_formated = "04.09.1995"
    static let overview = "movie_overview"
    static let popularity = 69.0
    static let genre = "genre_name"
    static let key = "movie_key"
}

struct TestMovieJSONData {
    
    static var jsonMovieData: NSMutableDictionary {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let movieObject: NSMutableDictionary = NSMutableDictionary()
        
        movieObject.setValue(TestMovieData.title, forKey: "title")
        movieObject.setValue(TestMovieData.poster_path, forKey: "poster_path")
        movieObject.setValue(TestMovieData.backdrop_path, forKey: "backdrop_path")
        movieObject.setValue(TestMovieData.id, forKey: "id")
        movieObject.setValue(TestMovieData.release_date, forKey: "release_date")
        movieObject.setValue(TestMovieData.overview, forKey: "overview")
        movieObject.setValue(TestMovieData.popularity, forKey: "popularity")
        
        jsonObject.setValue([movieObject], forKey: "results")
        
        return jsonObject
    }
    
    static var jsonMovieDetailData: NSMutableDictionary {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let movieDetailObject: NSMutableDictionary = NSMutableDictionary()
        
        
        movieDetailObject.setValue(TestMovieData.genre, forKey: "name")
        jsonObject.setValue([movieDetailObject], forKey: "genres")
        
        return jsonObject
    }
    
    static var jsonTrailerData: NSMutableDictionary {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let trailerObject: NSMutableDictionary = NSMutableDictionary()
        
        trailerObject.setValue(TestMovieData.key, forKey: "key")
        
        jsonObject.setValue([trailerObject], forKey: "results")
        
        return jsonObject
    }
    
}
