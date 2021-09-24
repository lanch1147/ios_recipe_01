//
//  ImageRequest.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/17/21.
//

import Foundation
import UIKit

struct ImageRequest: APIRequest {
    typealias Response = UIImage
    
    enum ImageRequestError: Error {
        case decodeImageFailure
    }
    
    let url: URL
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func decodeResponse(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.decodeImageFailure
        }
        return image
    }
}
