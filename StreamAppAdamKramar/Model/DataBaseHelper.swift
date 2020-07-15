//
//  DatabaseHelper.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 26/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation
import CoreData

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //save data to memory
    func saveMovies() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //clear all stored data
    func clearMovies(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    //load stored data from memory
    func loadMovies(with request: NSFetchRequest<Movie> = Movie.fetchRequest()) -> [Movie]? {
        do{
            let movieArray = try context.fetch(request)
            return movieArray 
        } catch {
            debugPrint(error)
            return nil
        }
    }
}

