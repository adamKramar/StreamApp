//
//  ViewController.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 24/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headStackView: UIStackView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    
    var selectedMovie: Movie?
    private var movieDetailManager = MovieDetailManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentScrollView.delegate = self
        contentScrollView.isDirectionalLockEnabled = true
        
        movieDetailManager.delegate = self
        
        //check connectivity
        if Connectivity.isConnectedToInternet {
            if let movie = selectedMovie {//get movie details from internert
                movieDetailManager.fetchMovieDetails(movie: movie)
            }
        } else {//get movie details from cache
            loadDataFromCache()
        }
        //chcek current device orientation - UI adjustment
        chceckOrientation()
    }
        
    //MARK: - Cache
    private func loadDataFromCache() {
        if let image = movieDetailManager.helper.getImageFromData(from: selectedMovie?.poster) {//get UIImage from stored data
            self.posterImageView.image = image
        }
        self.titleLabel.text = self.selectedMovie?.title
        self.dateLabel.text = selectedMovie?.release_date
        self.overviewLabel.text = selectedMovie?.overview
        self.genresLabel.text = selectedMovie?.genres
    }
    
    //MARK: - Video Player
    @IBAction func trailerButtonPressed(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet {//chcek connectivity
            if let movie = selectedMovie {
                movieDetailManager.fetchTrailerId(movie: movie)
            }
        } else {
            Alert.show(title: K.Text.noConnection, message: K.Error.watchTrailer, cancel: K.Text.okButton, ctrl: self)
        }
    }
    
    //Play movie trailer with key
    private func playVideo(key: String) {
        
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(key) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                let item = AVPlayerItem(url: streamURL)
                playerViewController?.player = AVPlayer(playerItem: item)
                playerViewController?.player?.play()
                NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishPlayback), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //playback has finished - dismiss video player
    @objc private func didFinishPlayback(notification: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - User Interface
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        chceckOrientation()
    }
    
    private func chceckOrientation() {
        if UIDevice.current.orientation.isLandscape {
            horizontalSetUp()
        } else {
            verticalSetUp()
        }
    }
    //landscape UI
    private func horizontalSetUp() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            posterImageView.contentMode = .scaleAspectFill
        }
        headStackView.axis = .horizontal
        headStackView.distribution = .fillEqually
        headStackView.alignment = .top
    }
    //portrait UI
    private func verticalSetUp() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            posterImageView.contentMode = .scaleAspectFit
        }
        headStackView.axis = .vertical
        headStackView.distribution = .fill
        headStackView.alignment = .fill
    }
}

//MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x != 0) {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }
    }
}

//MARK: - MovieListManagerDelegate
extension DetailViewController: MovieDetailManagerDelegate {
    
    func didUpdateTrailerId(_ movieDetailManager: MovieDetailManager, movie: Movie) {
        if let movieKey = movie.key {
            playVideo(key: movieKey)
        } else {
            Alert.show(title: K.Text.errorTitle, message: K.Error.videoKeyMissing , cancel: K.Text.okButton, ctrl: self)
        }
    }
    
    func didUpdateMovieDetails(_ movieDetailManager: MovieDetailManager, movie: Movie) {
        DispatchQueue.main.async {
            if let image = movieDetailManager.helper.getImageFromData(from: movie.poster) {
                self.posterImageView.image = image
            }
            self.titleLabel.text = self.selectedMovie?.title
            self.dateLabel.text = movie.release_date
            self.overviewLabel.text = movie.overview
            self.genresLabel.text = movie.genres
        }
    }
    
    func didFailWithError(errorDesc: String, error: Error?) {
        Alert.show(title: K.Text.errorTitle, message: errorDesc, cancel: K.Text.okButton, ctrl: self)
        if let e = error {
            debugPrint(e)
        }
    }
}

