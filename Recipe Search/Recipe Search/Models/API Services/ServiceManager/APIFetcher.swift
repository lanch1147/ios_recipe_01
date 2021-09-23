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
    private var cache = NSCache<NSString, AnyObject>()
    private var runningTasks = [UUID: URLSessionDataTask]()
    
    private init() {}
    
    private func cacheKey<Request: APIRequest>(for request: Request) -> NSString {
        guard let key = request.urlRequest.url?.absoluteString as NSString?
        else {
            fatalError("URLRequest does not contains url \(request.urlRequest)")
        }
        return key
    }
    
    func cachedResponse<Request: APIRequest>(of request: Request) -> Request.Response? {
        let key = cacheKey(for: request)
        return cache.object(forKey: key) as? Request.Response
    }
    
    private func storeResponse<Request: APIRequest>(_ response: Request.Response, of request: Request) {
        let key = cacheKey(for: request)
        cache.setObject(response, forKey: key)
    }
    
    func fetchData<Request: APIRequest>(with request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) -> UUID? {
        let urlRequest = request.urlRequest
        
        if let cachedData = cachedResponse(of: request) {
            completion(.success(cachedData))
            return nil
        }
        
        let taskID = UUID()
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            defer {
                self.runningTasks.removeValue(forKey: taskID)
            }
            
            if let error = error, (error as NSError).code != NSURLErrorCancelled {
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
                self.storeResponse(decodedData, of: request)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        runningTasks[taskID] = task
        return taskID
    }
    
    func cancelTask(with taskID: UUID) {
        runningTasks[taskID]?.cancel()
        runningTasks.removeValue(forKey: taskID)
    }
}
