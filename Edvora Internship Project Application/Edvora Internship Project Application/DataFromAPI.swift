//
//  DataFromAPI.swift
//  Edvora Internship Project Application
//
//  Created by Abdurakhmon Abdulatipov on 1/16/22.
//

import Foundation

struct Product: Decodable, Hashable {
    
    var product_name: String
    var brand_name: String
    var price: Int
    var address: Address
    var discription: String
    var date: String
    var time: String
    var image: String
}

struct Address: Decodable, Hashable {
    var state: String
    var city: String
}


class Api : ObservableObject{
    @Published var products = [Product]()
    @Published var uniqueProducts: [String] = []
    
    func loadData(completion:@escaping ([Product]) -> ()) {
        guard let url = URL(string: "https://assessment-edvora.herokuapp.com") else {
            print("Content Not Found!")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let products = try! JSONDecoder().decode([Product].self, from: data!)
            print(products)
            DispatchQueue.main.async {
                completion(products)
            }
        }.resume()
    }
}
