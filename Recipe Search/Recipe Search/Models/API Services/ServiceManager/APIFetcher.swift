//
//  APIFetcher.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/20/21.
//

import Foundation

class APIFetcher {
    enum APIServiceError: Error {
        case missingData
        case serverError
        case duplicateRequest
    }
    
    static let shared = APIFetcher()
    
    private init() {}
    
    func fetchData<Request: APIRequest>(with request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        let urlRequest = request.urlRequest
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIServiceError.serverError))
                return
            }
            guard let data = data else {
                completion(.failure(APIServiceError.missingData))
                return
            }
            
            do {
                let decodedData = try request.decodeResponse(from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
