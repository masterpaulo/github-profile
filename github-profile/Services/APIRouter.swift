//
//  APIRouter.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import Foundation

/// HTTP Method typs (only the basics)
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RouteConfig {
    typealias HeaderParams = [String: Any]
    typealias APIParams = [String: String]
    
    var method: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: HeaderParams { get }
    var params: APIParams { get }
    
    func asURLRequest() -> URLRequest?
}

extension RouteConfig {
    
    var baseURLString: String {
        return "https://api.github.com/" // Put in a constants file
    }
    
    
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
    
    var headers: HeaderParams {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}



enum APIRouter: RouteConfig {
    
    // MARK: - API Routes
    case getUsers(since: Int, pageSize: Int? = nil)
    case getUser(name: String)
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser:
            return .get
        }
    }
    
    
    var path: String {
        switch self {
        case .getUsers:
            return "users"
        case .getUser(let username):
            return "users/\(username)"
        }
    }
    
    var params: APIParams {
        switch self {
        case .getUsers(let since, let pageSize):
            var params: APIParams = APIParams()
            params["since"] = "\(since)"
            
            // Add 'per_page' query parameter only if exist and value is greater than zero
            if let perPage = pageSize, perPage > 0 {
                params["per_page"] = "\(perPage)"
            }
            return params
        default:
            return [:]
        }
    }
    
    func asURLRequest() -> URLRequest? {
        var urlString = self.url
        if method == .get, !params.isEmpty {
            let urlComp = NSURLComponents(string: self.url)!
            var items = [URLQueryItem]()
            
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
            
            items = items.filter{!$0.name.isEmpty}
            
            if !items.isEmpty {
                urlComp.queryItems = items
            }
            urlString = urlComp.url!.absoluteString
        }
        
        // URL
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Header fields
        headers.forEach({ header in
            urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        
        return urlRequest
    }
}
