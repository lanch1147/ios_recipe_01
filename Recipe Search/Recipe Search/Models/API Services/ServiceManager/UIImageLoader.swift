//
//  UIImageLoader.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/23/21.
//

import Foundation
import UIKit

class UIImageLoader {
    static let shared = UIImageLoader()
    private var imageMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView) {
        let imageRequest = ImageRequest(url: url)
        let taskID = APIFetcher.shared.fetchData(with: imageRequest) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            case .failure(let error):
                print(error)
            }
            self.imageMap.removeValue(forKey: imageView)
        }
        if let taskID = taskID {
            imageMap[imageView] = taskID
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let taskID = imageMap[imageView] {
            APIFetcher.shared.cancelTask(with: taskID)
            imageMap.removeValue(forKey: imageView)
        }
    }
}
