//
//  ListViewController.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 24/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var movieArray: [Movie] = []
    private var movieListManager = MovieListManager()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //table view prep
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)//no empty cells
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: K.List.movieCell, bundle: nil), forCellReuseIdentifier: K.List.movieCell)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)//pull down refresher
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        movieListManager.delegate = self
        //check connectivity
        if Connectivity.isConnectedToInternet {
            refresh()
        } else {//application will run in offline mode
            Alert.show(title: K.Text.noConnection, message: K.Error.connection, cancel: K.Text.okButton, ctrl: self)
            if let dbData = DataBaseHelper.shareInstance.loadMovies() {
                movieArray = dbData
                tableView.reloadData()
            } else {
                Alert.show(title: K.Text.errorTitle, message: K.Error.dbLoadFaild, cancel: K.Text.okButton, ctrl: self)
            }
        }
    }
    //refresh data
    @objc private func refresh() {
        movieArray = []
        DataBaseHelper.shareInstance.clearMovies(entity: K.List.movieEntity)
        movieListManager.fetchPopularMovieList()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let sortedArray = movieArray.sorted(by: { $0.popularity > $1.popularity })
        let movie = movieArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.List.movieCell, for: indexPath) as! MovieCell
        if let image = movieListManager.helper.getImageFromData(from: movie.image) {//get UIImage from image data
            cell.movieImage.image = image
        }
        cell.movieTitle.text = movie.title
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return CGFloat(K.List.listHeightPad)
        }
        return CGFloat(K.List.listHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.movieDetail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.movieDetail {
            let destiantionVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destiantionVC.selectedMovie = movieArray[indexPath.row]
            }
        }
    }
}

//MARK: - MovieListManagerDelegate
extension ListViewController: MovieListManagerDelegate {
    
    func didUpdateMovieList(_ movieManager: MovieListManager, movie: Movie) {
        DispatchQueue.main.async {
            self.movieArray.append(movie)
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(errorDesc: String, error: Error) {
        if errorDesc != K.Error.posterImage {
            Alert.show(title: K.Text.errorTitle, message: errorDesc, cancel: K.Text.okButton, ctrl: self)
        }
        debugPrint(error)
    }
}

//MARK: - UITextFieldDelegate
extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchFilter = textField.text {
            if let dbData = DataBaseHelper.shareInstance.loadMovies() {
                if searchFilter.count == 0 {
                    movieArray = dbData
                } else {
                    movieArray = dbData.filter {$0.title!.localizedCaseInsensitiveContains(searchFilter)}
                }
                tableView.reloadData()
            } else {
                Alert.show(title: K.Text.errorTitle, message: K.Error.dbLoadFaild, cancel: K.Text.okButton, ctrl: self)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let dbData = DataBaseHelper.shareInstance.loadMovies() {
            if textField.text?.count == 0 {
                movieArray = dbData
                tableView.reloadData()
            }
        } else {
            Alert.show(title: K.Text.errorTitle, message: K.Error.dbLoadFaild, cancel: K.Text.okButton, ctrl: self)
        }
    }
}

