//
//  HttpRequest.swift
//
//  Created by Eddie Long on 21/06/2019.
//

import Foundation

struct FormPart {
    let name: String
    let data: Data
    let filename: String
    let mimeType: String
}

enum HTTPPostData {
    case json(json: String)
    // Multipart request
    case formData(files: [String: FormPart])
    case binary(data: Data)
}

protocol HTTPRequest {
    
    var path: String { get } // Requires '/' at front
    var method: HTTPMethod { get }
    var query: [String: Any]? { get }
    var headers: [String: Any]? { get }
    var postBody: HTTPPostData? { get } // Only valid iff HTTPMethod == post, put
}

enum HTTPMethod: String {
    
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
    
}
