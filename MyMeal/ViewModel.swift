//
//  ViewModel.swift
//  MyMeal
//
//  Created by Divya Praveen on 2/7/24.
//

import Foundation

struct DessertMenu :Hashable, Decodable {
    let idMeal :String
    let strMealThumb : String
    let strMeal : String
}

class ViewModel: ObservableObject{
    
    @Published var recipes: [DessertMenu] = []
    func fetch() {
        guard let url = URL(string:
            "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data,_, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let responseData = try JSONDecoder().decode(ResponseData.self,from:
                    data)
                DispatchQueue.main.async {
                    self.recipes = responseData.meals
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
