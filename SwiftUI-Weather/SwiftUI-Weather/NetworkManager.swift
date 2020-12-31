//
//  NetworkManager.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/22/20.
//

import UIKit
import Moya

enum APIError: Error, LocalizedError {
    case moya(MoyaError)
    case backend(BackendError)
    case encoding(Error)
    case decoding(Error)
    case customError(String)
    case underlying(Error)
    case internalError
    
    var errorDescription: String? {
        switch self {
        case let .moya(error):
            return error.localizedDescription
        case let .encoding(error),
             let .underlying(error):
            return error.localizedDescription
        case let .decoding(error):
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case let .keyNotFound(key, context):
                    let path = (context.codingPath + [key]).map { $0.intValue.map(String.init) ?? $0.stringValue }.joined(separator: ".")
                    return "Field \(path) is missing."
                default:
                    break
                }
            }
            return error.localizedDescription
        case let .backend(error): return error.localizedDescription
        case let .customError(error): return error
        case .internalError: return "Oops! Internal server error. Please try again."
        }
    }
}

class NetworkManager {
    
    static var weatherBasePath: String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    
    static var weatherIconPath: String {
        return "https://openweathermap.org/img/wn/"
    }
    
    lazy var provider: MoyaProvider<MultiTarget> = {
        var plugins: [PluginType] = []
        #if DEBUG
        let loggerPlugin = NetworkLoggerPlugin()
        plugins.append(loggerPlugin)
        #endif
        
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = AppConstants.networkTimeout
        let session = Session(configuration: configuration, startRequestsImmediately: false)
        return MoyaProvider<MultiTarget>(session: session, plugins: plugins)
    }()
    
    static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Common Methods
    @discardableResult
    func requestDecoded<T: Decodable>(_ target: TargetType,
                                      to type: T.Type,
                                      callbackQueue: DispatchQueue? = .none,
                                      progress: ProgressBlock? = .none,
                                      completion: @escaping (Result<T, APIError>) -> Void) -> Cancellable {
        return provider.request(MultiTarget(target),
                                callbackQueue: callbackQueue,
                                progress: progress) { (result) in
            let result = NetworkManager.mapResult(result, to: type)
            completion(result)
        }
    }
    
    /// Maps default Moya result type 'Result<Response, MoyaError>' to concrete decodable 'Result<Decodable, APIError>'
    /// by parsing BackendError formats from either success or faulure response if needed, and by decoding response data
    /// to provided Decodable type
    class func mapResult<T: Decodable>(_ result: Result<Response, MoyaError>, to type: T.Type) -> Result<T, APIError> {
        switch result {
        case let .success(response):
            if response.statusCode >= 400 {
                let error = decodeBackendError(data: response.data, statusCode: response.statusCode)
                return .failure(error)
            }

            do {
                let decoded = try decoder.decode(type.self, from: response.data)
                return .success(decoded)
            } catch {
                if response.statusCode >= 500 {
                    return .failure(.internalError)
                } else {
                    return .failure(.decoding(error))
                }
            }
        case let .failure(error):
            if let response = error.response {
                let error = decodeBackendError(data: response.data, statusCode: response.statusCode)
                return .failure(error)
            }
            return .failure(.moya(error))
        }
    }
    
    class func decodeBackendError(data: Data, statusCode: Int) -> APIError {
        do {
            let decodedError = try decoder.decode(BackendError.self, from: data)
            return .backend(decodedError)
        } catch {
            if statusCode >= 500 {
                return .internalError
            } else {
                return .decoding(error)
            }
        }
    }
}


/// Possible error format that can be returned by backend
struct BackendError: Error, Decodable, LocalizedError {
    let cod: Int
    let message: String
}
