//
//  API.swift
//  CorkWeather
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

internal enum HTTPError: Error {
    case emptyData
    case statusCode(code: Int, data: Data?)
    case error(error: Error)
    case loggedOut
}

internal class HTTPResponse {
    let data: Data
    init(data: Data) {
        self.data = data
    }
    
    func toJson<T>() -> T? where T : Decodable, T : Encodable {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            /*if result.status != "success" {
                // TODO: Handle this properly
                print ("ERROR: \(result.status) with message \(result.message) and code \(result.code)")
                return nil
            }
            return result.data*/
            return result
        } catch {
            print(error)
            return nil
        }
    }
}

class APIClient {
    private let environment: Environment
    private let config: AppConfig
    
    lazy private var session: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    
    init(environment: Environment, config: AppConfig) {
        self.environment = environment
        self.config = config
    }
    
    enum HTTPServiceError: Error {
        case preparingURLRequestError
    }
    
    func perform(request: HTTPRequest, completion: @escaping (Result<HTTPResponse, Error>) -> Void) {
        guard let request = try? self.prepareURLRequest(for: request) else {
            return
        }
        let dataTask = session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            guard error == nil else {
                return completion(.failure(HTTPError.error(error: error!)))
            }
            
            guard let data = data else {
                return completion(.failure(HTTPError.emptyData))
            }
            
            guard let response = urlResponse as? HTTPURLResponse else { return }
            let statusCode = response.statusCode
            switch statusCode {
            case 200...299:
                completion(.success(HTTPResponse(data: data)))
            case 401:
                // time to re-auth!
                return completion(.failure(HTTPError.loggedOut))
            default:
                // status error
                return completion(.failure(HTTPError.statusCode(code: statusCode, data: data)))
            }
        })
        dataTask.resume()
    }
    
    private func prepareURLRequest(for request: HTTPRequest) throws -> URLRequest {
        let fullUrl = "\(environment.baseUrl)\(request.path)"
        var urlRequest = URLRequest(url: URL(string: fullUrl)!)
        
        if let query = request.query {
            var queryItems = [URLQueryItem]()
            
            for queryItem in query {
                if let queryStr = queryItem.value as? String {
                    queryItems.append(URLQueryItem(name: queryItem.key, value: queryStr))
                } else if let queryStrArray = queryItem.value as? [String], !queryStrArray.isEmpty {
                    for queryStrItem in queryStrArray {
                        queryItems.append(URLQueryItem(name: queryItem.key, value: queryStrItem))
                    }
                } else {
                    throw HTTPServiceError.preparingURLRequestError
                }
            }
            
            guard var components = URLComponents(string: fullUrl) else {
                throw HTTPServiceError.preparingURLRequestError
            }
            
            components.queryItems = queryItems
            urlRequest.url = components.url
        }
        
        if let postData = request.postBody {
            switch postData {
            case .json(let json):
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            case .binary(let data):
                // Rely on the HTTP Request for Content-Type
                urlRequest.httpBody = data
            case .formData(let files):
                let boundary = generateBoundary()
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let lineBreak = "\r\n"
                var body = Data()
                /*if let parameters = params {
                 for (key, value) in parameters {
                 body.append("--\(boundary  + lineBreak)")
                 body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                 body.append("\(String(describing: value) + lineBreak)")
                 }
                 }*/
                
                for (_, part) in files {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(part.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(part.mimeType + lineBreak + lineBreak)")
                    body.append(part.data)
                    body.append(lineBreak)
                }
                
                body.append("--\(boundary)--\(lineBreak)")
                urlRequest.httpBody = body
            }
        }
        
        request.headers?.forEach { urlRequest.addValue($0.value as? String ?? "", forHTTPHeaderField: $0.key) }
        
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}
