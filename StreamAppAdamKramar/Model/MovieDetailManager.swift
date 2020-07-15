//
//  MovieDetailManager.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 25/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation
import Alamofire

protocol MovieDetailManagerDelegate {
    
    func didUpdateMovieDetails(_ movieDetailManager: MovieDetailManager, movie: Movie)
    func didUpdateTrailerId(_ movieDetailManager: MovieDetailManager, movie: Movie)
    func didFailWithError(errorDesc: String, error: Error?)
}

struct MovieDetailManager {
    
    var delegate: MovieDetailManagerDelegate?
    let helper = MovieManagerHelper()
    
    private let client = Client()
    
    //get id of movie traler and store it
    func fetchTrailerId(movie: Movie) {
        let url = "\(K.Api.apiUrl)\(String(movie.id))/videos\(K.Api.apiKey)"
        client.performRequestWithJSONResponse(with: url) { (error, data) in
            if let e = error {
                self.delegate?.didFailWithError(errorDesc: K.Error.trailer, error: e)
            }
            if let safeData = data {
                self.parseTrailerData(from: safeData) { (error, trailers) in
                    if let e = error {
                        self.delegate?.didFailWithError(errorDesc: K.Error.decodeData, error: e)
                    }
                    if let results = trailers?.results {
                        if results.count > 1 {
                            movie.key = results[0].key // get only first trailer
                            DataBaseHelper.shareInstance.saveMovies() //save data
                            self.delegate?.didUpdateTrailerId(self, movie: movie)
                        } else {
                            self.delegate?.didFailWithError(errorDesc: K.Error.noTrailer, error: nil)
                        }
                    }
                }
            }
        }
    }
        
    //get rest of movie details and update stored data
    func fetchMovieDetails(movie: Movie) {
        let url = "\(K.Api.apiUrl)\(String(movie.id))\(K.Api.apiKey)"
        client.performRequestWithJSONResponse(with: url) { (error, data) in
            if let e = error {
                self.delegate?.didFailWithError(errorDesc: K.Error.movieDetail, error: e)
            }
            if let safeData = data {
                self.parseMovieDetailData(from: safeData) { (error, movieData) in
                    if let e = error {
                        self.delegate?.didFailWithError(errorDesc: K.Error.decodeData, error: e)
                    }
                    if let data = movieData {
                        let genres = self.helper.formatGenres(genres: data.genres)
                        movie.genres = genres //update selected movie
                        DataBaseHelper.shareInstance.saveMovies() // save data
                        self.delegate?.didUpdateMovieDetails(self, movie: movie)
                    }
                }
            }
        }
    }
    
    //parse JSON data
    func parseTrailerData(from data: Data, completion: @escaping(Error?, Trailers?)->()) {
        let decoder = JSONDecoder()
        do {//decode JSON response
            let decodedData = try decoder.decode(Trailers.self, from: data)
            completion(nil, decodedData)
        } catch {
            completion(error, nil)
        }
    }
    
    //parse JSON data
    func parseMovieDetailData(from data: Data , completion: @escaping(Error?, MovieDetailData?)->()) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieDetailData.self, from: data)
            completion(nil, decodedData)
        } catch {
            completion(error, nil)
        }
    }
}
