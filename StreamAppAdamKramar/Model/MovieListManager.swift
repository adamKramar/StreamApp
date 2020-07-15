//
//  MovieListManager.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 24/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData


protocol MovieListManagerDelegate {
    
    func didUpdateMovieList(_ movieManager: MovieListManager, movie: Movie)
    func didFailWithError(errorDesc: String, error: Error)
}


struct MovieListManager {
    
    var delegate: MovieListManagerDelegate?
    let helper = MovieManagerHelper()
    
    private let clinet = Client()
    
    //get list of popular movies and insert them into memory
    func fetchPopularMovieList() {
        let url = "\(K.Api.apiUrl)popular\(K.Api.apiKey)"
        clinet.performRequestWithJSONResponse(with: url) { (error, data) in
            if let e = error {
                self.delegate?.didFailWithError(errorDesc: K.Error.popularList, error: e)
            }
            if let safeData = data {//unwrap recieved data
                self.parseMovieData(from: safeData) { (error, decodedData) in
                    if let e = error {
                        self.delegate?.didFailWithError(errorDesc: K.Error.decodeData, error: e)
                    }
                    if let results = decodedData?.results {
                        _ = results.map {self.saveMovieData(movie: $0)}
                    }
                }
            }
        }
    }
    
    private func saveMovieData(movie selectedMovie: MovieData) {
        
        let movie = Movie(context: DataBaseHelper.shareInstance.context)//new core data object
        let formatedDate = self.helper.formatDate(date: selectedMovie.release_date)//change format of date string
        
        getImage(movie: selectedMovie, from: selectedMovie.backdrop_path) { (error, image) in
            if let e = error {
                self.delegate?.didFailWithError(errorDesc: K.Error.posterImage, error: e)
            }
            if let imgBackdrop = image {
                movie.title = selectedMovie.title
                movie.image = imgBackdrop
                movie.id = Int64(selectedMovie.id)
                movie.overview = selectedMovie.overview
                movie.release_date = formatedDate
                movie.popularity = selectedMovie.popularity
                DataBaseHelper.shareInstance.saveMovies()//save data
                self.delegate?.didUpdateMovieList(self, movie: movie)
            }
        }
        
        getImage(movie: selectedMovie, from: selectedMovie.poster_path) { (error, image) in
            if let e = error {
                self.delegate?.didFailWithError(errorDesc: K.Error.posterImage, error: e)
            }
            if let imgPoster = image {
                movie.poster = imgPoster
                DataBaseHelper.shareInstance.saveMovies()//save data
            }
        }
    }
    
    private func getImage(movie selectedMovie: MovieData, from path: String, completion: @escaping(Error?, Data?)->()) {
        let url = "\(K.Api.imgPath)\(path)"
        clinet.performRequestWithImageResponse(with: url) { (error, image) in
            if error != nil {
                completion(error, nil)
            }
            if image != nil{
                completion(nil, image)
            }
        }
    }
    
    //decode JSON data
    func parseMovieData(from data: Data, completion: @escaping(Error?, Movies?)->()) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Movies.self, from: data)
            completion(nil, decodedData)
        } catch {
            completion(error, nil)
        }
    }
    
}
