//
//  DataBaseHelperTest.swift
//  StreamAppAdamKramarTests
//
//  Created by Adam Kramar on 15/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

@testable import StreamAppAdamKramar
import XCTest

class DataBaseHelperTest: XCTestCase {
    
    func test_data_model_load() {
        let dbData = DataBaseHelper.shareInstance.loadMovies()
        
        XCTAssertNotNil(dbData)
    }

    
    func test_data_model_clear() {
        DataBaseHelper.shareInstance.clearMovies(entity: K.List.movieEntity)
        let dbData = DataBaseHelper.shareInstance.loadMovies()
        
        XCTAssertEqual(dbData, [])
    }
    
    func test_data_model_save() {
        DataBaseHelper.shareInstance.clearMovies(entity: K.List.movieEntity)//clear data
        
        let movie = Movie(context: DataBaseHelper.shareInstance.context)//new core data object
        movie.title = TestMovieData.title
        movie.id = TestMovieData.id
        movie.image = TestMovieData.image
        movie.overview = TestMovieData.overview
        movie.release_date = TestMovieData.release_date
        movie.popularity = TestMovieData.popularity
        
        DataBaseHelper.shareInstance.saveMovies()//save data
        
        let dbData = DataBaseHelper.shareInstance.loadMovies()
        
        XCTAssertNotNil(dbData)
        
        if let data = dbData {
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(data[0].title, TestMovieData.title)
            XCTAssertEqual(data[0].id, TestMovieData.id)
            XCTAssertEqual(data[0].image, TestMovieData.image)
            XCTAssertEqual(data[0].overview, TestMovieData.overview)
            XCTAssertEqual(data[0].release_date, TestMovieData.release_date)
            XCTAssertEqual(data[0].popularity, TestMovieData.popularity)
        }
        
        DataBaseHelper.shareInstance.clearMovies(entity: K.List.movieEntity)
        let newDbData = DataBaseHelper.shareInstance.loadMovies()
        
        XCTAssertEqual(newDbData, [])
    }
}
