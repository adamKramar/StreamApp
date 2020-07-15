//
//  MovieManagerHelper.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 14/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation

struct MovieManagerHelper {
    
    //change format of date string
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: dateObj)
        }
        return date
    }
    
    //get image from data
    func getImageFromData(from data: Data?) -> UIImage? {
        if let safeData = data {
            return UIImage(data: safeData)
        }
        return nil
    }
    
    //format genres into string separeted by ", "
    func formatGenres(genres: [Genre]) -> String {
        var genreArray: [String] = []
        for genre in genres {
            genreArray.append(genre.name)
        }
        return genreArray.joined(separator: ", ")
    }
    
}
