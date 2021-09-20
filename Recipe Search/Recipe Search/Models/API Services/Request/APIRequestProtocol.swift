//
//  APIRequestProtocol.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/20/21.
//

import Foundation

protocol APIRequest {
    associatedtype Response: AnyObject
    
    var urlRequest: URLRequest { get }
    
    func decodeResponse(from data: Data) throws -> Response
}
