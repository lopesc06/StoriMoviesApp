
enum NetworkManagerErrorsEnum: Error {
    case invalidUrl
    case invalidUrlContent
    case decodingFailed(error: DecodingError)
    case encodingFailed
    case HttpError(statusCode: Int)
    case unexpectedError
}
