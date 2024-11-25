//
//  MovieDataCellProtocol.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

protocol MovieDataCellProtocol: MovieProtocol {
    var posterUIImage: UIImage? { get set }
}

struct HomeViewMovieData: MovieDataCellProtocol {
    var adult: Bool
    var backdrop_path: String?
    var genre_ids: [Int]
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String?
    var release_date: String?
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
    var posterUIImage: UIImage?
    
    init(movie: MovieProtocol) {
        adult = movie.adult
        backdrop_path = movie.backdrop_path
        genre_ids = movie.genre_ids
        id = movie.id
        original_language = movie.original_language
        original_title = movie.original_title
        overview = movie.overview
        popularity = movie.popularity
        poster_path = movie.poster_path
        title = movie.title
        video = movie.video
        vote_average = movie.vote_average
        vote_count = movie.vote_count
        release_date = movie.release_date
    }
    
}
