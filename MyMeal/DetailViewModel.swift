////
////  DetailViewModel.swift
////  MyMeal
////
////  Created by Divya Praveen on 2/7/24.
////
//
import Foundation

class DetailViewModel: ObservableObject{
    @Published var jsonData: [DetailMenu] = []
 

    func fetchData(withQuery query :String) {
      
        var components = URLComponents(string: "https://themealdb.com/api/json/v1/1/lookup.php")!
           components.queryItems = [
               URLQueryItem(name: "i", value: query)
               
           ]
        guard let url = components.url else {
            return
        }

     URLSession.shared.dataTask(with: url) {
             data, _, error in
            guard let data = data, error == nil else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
          
            do {
                let decodedData = try JSONDecoder().decode(SingleDessert.self, from: data)
                print(decodedData)
                DispatchQueue.main.async {
                    self.jsonData = decodedData.meals
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
         }
            .resume()
    }
}


struct DetailMenu : Decodable {
    let idMeal :String
    let strMealThumb : String
    let strMeal : String
    let strCategory : String
    let strInstructions:String
    let strYoutube: String
    let strSource:String
    let strIngredient1 : String
    let strIngredient2 : String
    let strIngredient3 : String
    let strIngredient4 : String
    let strIngredient5 : String
    let strIngredient6 : String
    let strIngredient7 : String
    let strIngredient8 : String
    let strIngredient9 : String
    let strIngredient10 : String
    let strIngredient11 : String
    let strIngredient12 : String
    let strIngredient13 : String
    let strIngredient14 : String
    let strIngredient15 : String
    let strIngredient16 : String
    let strIngredient17 : String
    let strIngredient18 : String
    let strIngredient19 : String
    let strIngredient20 : String
    let strMeasure1:String
    let strMeasure2:String
    let strMeasure3:String
    let strMeasure4:String
    let strMeasure5:String
    let strMeasure6:String
    let strMeasure7:String
    let strMeasure8:String
    let strMeasure9:String
    let strMeasure10:String
    let strMeasure11:String
    let strMeasure12:String
    let strMeasure13:String
    let strMeasure14:String
    let strMeasure15:String
    let strMeasure16:String
    let strMeasure17:String
    let strMeasure18:String
    let strMeasure19:String
    let strMeasure20:String
}

