import Foundation

protocol EndpointProtocol {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var method: HtppMethodEnum { get }
    var queryParameters: [URLQueryItem] { get }
    var headers: [String : String] { get }
    var httpBody: Data? { get }
    var timeoutInterval: TimeInterval { get }
}

extension EndpointProtocol {
    var scheme: String { "https" }
    var host: String { Constants.host }
    var timeoutInterval: TimeInterval { 5 }
}


struct TopRatedListEndpoint: EndpointProtocol {
    
    var port: Int?
    var path: String = "/3/movie/top_rated"
    var method: HtppMethodEnum = .GET
    var httpBody: Data?
    var queryParameters: [URLQueryItem] = []
    var headers: [String : String] = [
        "accept": "application/json",
        "Authorization": "Bearer \(Constants.token)"
    ]
    
    init(page: String, language: String = "en-US") {
        queryParameters.append(URLQueryItem(name: "language", value: language))
        queryParameters.append(URLQueryItem(name: "page", value: page))
    }
    
}
