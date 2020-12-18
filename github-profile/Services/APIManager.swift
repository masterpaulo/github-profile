//
//  APIManager.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import Foundation

class APIManager {
    
    private let queue = DispatchQueue.global(qos: .background)
    private let semaphore = DispatchSemaphore(value: 1) // Change value to allow maximum of concurrent network task
    
    /// Perform API requests with a given route
    ///
    /// - Parameters:
    ///   - route: A RouteConfig value describing the API resource
    private func request<T: Codable>(route: RouteConfig, completion: @escaping (Result<T, Error>)->Void) {

        let session = URLSession.shared

        let urlRequest = route.asURLRequest()!
        
        print(urlRequest.curlString) // for debugging
        
        queue.async {
            self.semaphore.wait()
            let task = session.dataTask(with: urlRequest) { data, response, error in
                defer {
                    self.semaphore.signal()
                }
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(object))
                }
                catch let err {
                    completion(.failure(err))
                }
            }

            task.resume()
        }
    }
}

// MARK: - Methods

extension APIManager {
    /// Get list of users
    /// - Parameters:
    ///   - since: The integer ID of the last User that you've seen.
    ///   - completion: Callback that provides a Result of User array
    func getUsers(since: Int = 0, pageSize: Int? = nil, completion: @escaping (Result<[User], Error>) -> Void) {
        request(route: APIRouter.getUsers(since: since, pageSize: pageSize), completion: completion)
    }
    
    /// Get profile details of a specific user
    /// - Parameters:
    ///   - username: The username of the User
    ///   - completion: Callback that provides a Result of User object
    func getUser(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        request(route: APIRouter.getUser(name: username), completion: completion)
    }
}


extension URLRequest {

    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }

}
