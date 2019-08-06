//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        self.imageView.image = UIImage(named: "PosterPlaceholder")
        if let posterPath = movie.posterPath {
            TMDBClient.getPosterImage(imagePath: posterPath) { (data, error) in
                guard let data = data else {
                    return
                }
                let downloadedImage = UIImage(data: data)
                self.imageView.image = downloadedImage
            }
        }
        
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.addToWatchList(movieId: movie.id, watchlist: !isWatchlist, completion: handleWatchListResponse(success:error:))
    }
    
    func handleWatchListResponse(success: Bool, error: Error?){
        if success {
            if isWatchlist {
                MovieModel.watchlist.filter(){$0 != self.movie}
            } else {
                MovieModel.watchlist.append(movie)
            }
        }
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.addToFavorites(movieId: movie.id, favorite: !isFavorite, completion: handleFavoritesList(success:error:))
    }
    
    func handleFavoritesList(success: Bool, error: Error?){
        if success {
            if isFavorite{
                MovieModel.favorites.filter(){$0 != self.movie}
            } else {
                MovieModel.watchlist.append(movie)
            }
        }
        toggleBarButton(favoriteBarButtonItem, enabled: isWatchlist)
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    
}
