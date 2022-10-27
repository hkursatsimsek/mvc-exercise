//
//  NetworkManager.swift
//  FlickerClientApp
//
//  Created by Kürşat Şimşek on 26.10.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchImage(with url: String?, completion: @escaping (Data) -> Void) {
        if let urlString = url {
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }).resume()
        }
    }
    
}
