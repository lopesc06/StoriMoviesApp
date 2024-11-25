//
//  ImageManager.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import UIKit

final class ImageManager {
    static func callService(urlString: String, completion:  @escaping (Result<UIImage, Error>) -> ()) {
        do {
            guard let url = URL(string: urlString) else { throw NetworkManagerErrorsEnum.invalidUrl }
            let urlRequest = URLRequest(url: url, timeoutInterval: 5)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    guard let httpResponse = response as? HTTPURLResponse else { throw NetworkManagerErrorsEnum.unexpectedError }
                    guard 200..<300 ~= httpResponse.statusCode else { throw NetworkManagerErrorsEnum.HttpError(statusCode: httpResponse.statusCode) }
                    guard let unwrappedData = data, let image = UIImage(data: unwrappedData) else { throw NetworkManagerErrorsEnum.unexpectedError }
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                
            }.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
