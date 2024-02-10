//
//  ContentView.swift
//  MyMeal
//
//  Created by Divya Praveen on 2/5/24.
//

import SwiftUI

struct ContentView: View {
   
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing:10){
                    ForEach(viewModel.recipes,id: \.idMeal){recipe in
                      NavigationLink(destination : RecipeDetailView(recipe:recipe)){
                                HStack {
                                URLImage(urlString: recipe.strMealThumb)
                                    .frame(width: 100,height:100)
                                    .background(Color.gray)
                                Text(recipe.strMeal)
                                    .bold()
                                    .padding(.leading,10)
                                    Spacer()
                            }
                           
                        }
                        .padding(10)
                   }
                    
               }
               .padding(.horizontal)
               .padding(.bottom, 20)
               .frame(maxWidth: .infinity)
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
    @StateObject var detailModel = DetailViewModel()
    
    let recipe: DessertMenu
    
    var body: some View {
        NavigationView {
            VStack {
                if detailModel.jsonData.isEmpty {
                    Text("Loading...")
                        .padding()
                } else{
                    
                    
                    List(detailModel.jsonData, id: \.idMeal) { detailMenu in
                        VStack {
                            AsyncImage(url:URL(string:detailMenu.strMealThumb )){
                                image in image
                                    .image?.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                            }
                            Link(" For More Details!!",destination: URL(string: detailMenu.strSource)!)
                                .font(.title3)
                                .foregroundColor(.red)
                                .underline()
                                .padding(10)
                            
                            Link("Youtube Video",destination: URL(string: detailMenu.strYoutube)!)
                                .font(.title3)
                                .foregroundColor(.red)
                                .underline()
                                .padding(10)
                            Text("Instructions: ").bold().underline().padding(10)
                            Text(detailMenu.strInstructions)
                            
                            Text("Ingredients: ").bold().underline().padding(10)
                            VStack(alignment: .leading) {
                                ForEach(1...20, id: \.self) { i in
                                    if let ingredient = getIngredient(i: i, detailMenu: detailMenu),
                                       let measure = getMeasure(i: i, detailMenu: detailMenu),
                                       !ingredient.isEmpty && !measure.isEmpty {
                                        Text("\(ingredient)  :  \(measure)").padding(5)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    .listStyle(PlainListStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(recipe.strMeal)
            .onAppear {
                detailModel.fetchData(withQuery: recipe.idMeal)
            }
           
        }
       
    }
       
    
    private func getIngredient(i: Int, detailMenu: DetailMenu) -> String? {
        let mirror = Mirror(reflecting: detailMenu)
        let ingredient = mirror.children.first { $0.label == "strIngredient\(i)" }?.value as? String
        return ingredient
    }
    
    private func getMeasure(i: Int, detailMenu: DetailMenu) -> String? {
        let mirror = Mirror(reflecting: detailMenu)
        let measure = mirror.children.first { $0.label == "strMeasure\(i)" }?.value as? String
        return measure
    }
}



struct ResponseData: Decodable {
    let meals: [DessertMenu]
}

struct SingleDessert:Decodable{
    let meals : [DetailMenu]
}


enum DRError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

#Preview {
    ContentView()
}

