//
//  NetworkManager.swift
//  Homework 2.10 URLSession
//
//  Created by Almas Selbayev on 10.04.2022.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchHouse(completion: @escaping ([House]) -> Void)  {
        guard let url = URL(string: "https://wizard-world-api.herokuapp.com/Houses") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            do {
                let houses = try JSONDecoder().decode([House].self, from: data)
                DispatchQueue.main.async {
                    completion(houses)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    
    }
}
