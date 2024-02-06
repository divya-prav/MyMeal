//
//  ContentView.swift
//  MyMeal
//
//  Created by Divya Praveen on 2/5/24.
//

import SwiftUI


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

struct ContentView: View {
   
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            List{
                ForEach(viewModel.recipes,id: \.self){recipe in
                    HStack {
                        NavigationLink(destination : RecipeDetailView(recipe:recipe)){
                            URLImage(urlString: recipe.strMealThumb)
                                .frame(width: 100,height:100)
                                .background(Color.gray)
                            Text(recipe.strMeal)
                                .bold()
                            
                        }
                       
                    }
                    .padding(10)
                }
                
            }
            .navigationTitle("Dessert")
            .onAppear{
                viewModel.fetch()
            }
        }
       
    }
   
}

struct URLImage : View {
    let urlString : String
    
    @State var data: Data?
    
    var body: some View{
        if let data = data,let uiimage = UIImage(data:data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100,height: 100)
                .background(Color.gray)
            
        }else{
            Image(systemName: "Dessert")
                .frame(width: 100,height: 100)
                .background(Color.gray)
                .onAppear(){
                    fetchData()
                }
        }
    }
    
    private func fetchData(){
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){data, _ , _ in self.data = data
        }
        task.resume()
    }
}

struct RecipeDetailView: View {
    let recipe: DessertMenu

    var body: some View {
        VStack {
            Text(recipe.strMeal)
            // Add more details as needed
        }
        .navigationTitle(recipe.strMeal)
    }
}

struct ResponseData: Decodable {
    let meals: [DessertMenu]
}


struct DessertMenu :Hashable, Decodable {
    let strMealThumb : String
    let strMeal : String
}

enum DRError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

#Preview {
    ContentView()
}

