import SwiftUI
import Combine

enum HtppMethodEnum: String {
    case GET
    case POST
    case PUT
    case DELETE
}

final class HttpNetworkManager {
    
    private init() {}
    
    private static func createUrlRequest(endpoint: EndpointProtocol) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.port = endpoint.port
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryParameters
        
        guard let url = urlComponents.url else { throw NetworkManagerErrorsEnum.invalidUrl }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.httpBody
        urlRequest.timeoutInterval = endpoint.timeoutInterval
        for header in endpoint.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }
    
    static func callService<Response: Decodable>(endpoint: EndpointProtocol, completion:  @escaping (Result<Response, Error>) -> ()) {
        do {
            let url = try createUrlRequest(endpoint: endpoint)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    if let error = error { throw error }
                    guard let httpResponse = response as? HTTPURLResponse else { throw NetworkManagerErrorsEnum.unexpectedError }
                    guard 200..<300 ~= httpResponse.statusCode, let jsonData = data else { throw NetworkManagerErrorsEnum.HttpError(statusCode: httpResponse.statusCode) }
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                } catch let error as DecodingError {
                    switch error {
                        case .typeMismatch(let key, let value):
                            print("error: \(key) \nvalue: \(value) \nERROR: \(error.localizedDescription)")
                        case .valueNotFound(let key, let value):
                            print("error: \(key) \nvalue: \(value) \nERROR: \(error.localizedDescription)")
                        case .keyNotFound(let key, let value):
                            print("error: \(key) \nvalue: \(value) \nERROR: \(error.localizedDescription)")
                        
                        default:
                            print("ERROR: \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        completion(.failure(NetworkManagerErrorsEnum.decodingFailed(error: error)))
                    }
                } catch {
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
