//
//  BaseComponentsProvider.swift
//  Recipe Search
//
//  Created by Lan Chu on 9/14/21.
//

import Foundation

class BaseComponentProvider {
    static let shared = BaseComponentProvider()
    
    private let baseURL = "https://api.edamam.com/api/recipes/v2"
    private let typeItem = URLQueryItem(name: "type", value: "public")
    private lazy var appKeyItem: URLQueryItem = {
        let value = readInfoList(forKey: "APP_KEY")
        return URLQueryItem(name: "app_key", value: value)
    }()
    private lazy var appIDItem: URLQueryItem = {
        let value = readInfoList(forKey: "APP_ID")
        return URLQueryItem(name: "app_id", value: value)
    }()
    
    private init() {}
    
    private func readInfoList(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty
        else {
            fatalError("Coundn't find key \(key) in 'Info.plist'")
        }
        return value
    }
    
    func createBaseComponents() -> URLComponents {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("Base URL is not correct")
        }
        components.queryItems = [typeItem, appKeyItem, appIDItem]
        return components
    }
}
