//
//  MovieManagerTest.swift
//  StreamAppAdamKramarTests
//
//  Created by Adam Kramar on 15/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

@testable import StreamAppAdamKramar
import XCTest

class MovieManagerTest: XCTestCase {
    
    var movieListManager: MovieListManager!
    var movieDetailManager: MovieDetailManager!

    override func setUp() {
        super.setUp()
        movieListManager = MovieListManager()
        movieDetailManager = MovieDetailManager()
    }

    override func tearDown() {
        movieListManager = nil
        movieDetailManager = nil
        super.tearDown()
    }
    
    func test_parse_movie_list () {
        let rawData = TestMovieJSONData.jsonMovieData
        XCTAssertNotNil(rawData)
        do {
            let json = try JSONSerialization.data(withJSONObject: rawData, options: JSONSerialization.WritingOptions())
            movieListManager.parseMovieData(from: json) { (error, data) in
                XCTAssertNil(error)
                XCTAssertNotNil(data)
                if let safeData = data {
                    XCTAssertEqual(safeData.results.count, 1)
                    XCTAssertEqual(safeData.results[0].title, TestMovieData.title)
                    XCTAssertEqual(safeData.results[0].poster_path, TestMovieData.poster_path)
                    XCTAssertEqual(safeData.results[0].backdrop_path, TestMovieData.backdrop_path)
                    XCTAssertEqual(Int64(safeData.results[0].id), TestMovieData.id)
                    XCTAssertEqual(safeData.results[0].release_date, TestMovieData.release_date)
                    XCTAssertEqual(safeData.results[0].overview, TestMovieData.overview)
                    XCTAssertEqual(safeData.results[0].popularity, TestMovieData.popularity)
                }
            }
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_parse_trailer_data() {
        let rawData = TestMovieJSONData.jsonTrailerData
        XCTAssertNotNil(rawData)
        do {
            let json = try JSONSerialization.data(withJSONObject: rawData, options: JSONSerialization.WritingOptions())
            movieDetailManager.parseTrailerData(from: json) { (error, data) in
                XCTAssertNil(error)
                XCTAssertNotNil(data)
                if let safeData = data {
                    XCTAssertEqual(safeData.results.count, 1)
                    XCTAssertEqual(safeData.results[0].key, TestMovieData.key)
                }
            }
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_parse_movie_detail_data() {
        let rawData = TestMovieJSONData.jsonMovieDetailData
        XCTAssertNotNil(rawData)
        do {
            let json = try JSONSerialization.data(withJSONObject: rawData, options: JSONSerialization.WritingOptions())
            movieDetailManager.parseMovieDetailData(from: json) { (error, data) in
                XCTAssertNil(error)
                XCTAssertNotNil(data)
                if let safeData = data {
                    XCTAssertEqual(safeData.genres.count, 1)
                    XCTAssertEqual(safeData.genres[0].name, TestMovieData.genre)
                }
            }
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_format_date() {
        XCTAssertEqual(TestMovieData.release_date_formated, movieListManager.helper.formatDate(date: TestMovieData.release_date))
    }
    
    func test_format_genres() {
        let genreList = [Genre(name: "genre_1"), Genre(name: "genre_2"), Genre(name: "genre_3")]
        let genreString = "genre_1, genre_2, genre_3"
        
        XCTAssertEqual(movieListManager.helper.formatGenres(genres: genreList), genreString)
        
    }
    
}

