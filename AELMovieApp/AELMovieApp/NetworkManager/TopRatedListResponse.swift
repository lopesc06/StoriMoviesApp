//
//  TopRatedListResponse.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

//{
//      "adult": false,
//      "backdrop_path": "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
//      "genre_ids": [
//        18,
//        80
//      ],
//      "id": 278,
//      "original_language": "en",
//      "original_title": "The Shawshank Redemption",
//      "overview": "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
//      "popularity": 98.25,
//      "poster_path": "/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
//      "release_date": "1994-09-23",
//      "title": "The Shawshank Redemption",
//      "video": false,
//      "vote_average": 8.7,
//      "vote_count": 23656
//    }

import Foundation

struct TopRatedListResponse: Decodable {
    var page: Int
    var results: [MovieResponse]
    var total_pages: Int
    var total_results: Int
    
}

protocol MovieProtocol {
    var adult: Bool { get set }
    var backdrop_path: String? { get set }
    var genre_ids: [Int] { get set }
    var id: Int { get set }
    var original_language: String { get set }
    var original_title: String { get set }
    var overview: String { get set }
    var popularity: Double { get set }
    var poster_path: String? { get set }
    var release_date: String? { get set }
    var title: String { get set }
    var video: Bool { get set }
    var vote_average: Double { get set }
    var vote_count: Int { get set }
}


struct MovieResponse: MovieProtocol, Decodable {
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
}
