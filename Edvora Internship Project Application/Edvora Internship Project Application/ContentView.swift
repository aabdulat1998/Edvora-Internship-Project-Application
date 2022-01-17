//
//  ContentView.swift
//  Edvora Internship Project Application
//
//  Created by Abdurakhmon Abdulatipov on 1/16/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var products = [Product]()
    @State var filteredProducts = [Product]()
    @State var test: Bool = false
    
    @State var showFilterPopUp: Bool = false
    @State var productFilter: String = "Products"
    @State var stateFilter: String = "State"
    @State var cityFilter: String = "City"
    @State var showProductFilter: Bool = false
    @State var showStateFilter: Bool = false
    @State var showCityFilter: Bool = false
    
    @State var filterCounter: Int = 0
    @State var productArr: [String] = []
    @State var stateArr: [String] = []
    @State var cityArr: [String] = []
    
    var body: some View {
        
        ZStack {
            Color(.black).opacity(0.8).ignoresSafeArea()
            
            VStack (alignment: .leading) {
                
                Text("Edvora").foregroundColor(.white).font(.largeTitle.bold()).padding(.vertical, 10)
            
                HStack {
                    HStack{
                        Text("Filters").foregroundColor(.white).font(.title3).padding(.leading, 10)
                        
                        if filterCounter > 0 {
                            Text("(\(filterCounter))").foregroundColor(.white).font(.title3)
                        }
                        
                        Spacer()
                        
                        Image(systemName: showFilterPopUp ? "chevron.down" : "chevron.right").foregroundColor(.white).padding(.horizontal, 10).onTapGesture() {
                            showFilterPopUp = true
                        }
                            
                    }.padding(.vertical, 5)
                        .frame(maxWidth: UIScreen.main.bounds.size.width * 0.45)
                    
                        .background(RoundedRectangle(cornerRadius: 10).fill(.black.opacity(0.3)))
                    
                    Spacer()
                    
                    //Clears all of the arrays and resets them using the original [Product] from the .onAppear function.
                    Button(action: {
                        productFilter = "Products"
                        stateFilter = "State"
                        cityFilter = "City"
                        filterCounter = 0
                        
                        filteredProducts = products
                        
                        productArr.removeAll()
                        stateArr.removeAll()
                        cityArr.removeAll()
                        for product in products {
                            productArr.append(product.brand_name)
                            stateArr.append(product.address.state)
                            cityArr.append(product.address.city)
                        }
                        productArr = Array(Set(productArr))
                        stateArr = Array(Set(stateArr))
                        cityArr = Array(Set(cityArr))
                        
                    }) {Text("clear filter")
                        .font(.body).padding(5).foregroundColor(.white)}.background(RoundedRectangle(cornerRadius: 10).fill(.black.opacity(0.3)))
                }
                
                ScrollView {
                    ForEach(productArr, id: \.self) { uniqueProduct in
                        HStack {
                            Text(uniqueProduct).font(.title2).foregroundColor(.white)
                            Spacer()
                        }
                        ExDivider()
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(filteredProducts, id: \.self) { product in
                                    if product.brand_name == uniqueProduct {
                                        ZStack {
                                            VStack (alignment: .leading){
                                                HStack {
                                                    AsyncImage(url: URL(string: product.image),
                                                               content: { image in
                                                                   image.resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(maxWidth: 60, maxHeight: 60)
                                                               }, placeholder: {
                                                                   ProgressView()
                                                               })
                                                    VStack (alignment: .leading){
                                                        Text(product.product_name).foregroundColor(.white).font(.footnote)
                                                        Text(product.brand_name).foregroundColor(.gray).font(.caption)
                                                        Text("$" + String(product.price)).foregroundColor(.white).font(.footnote)
                                                    }
                                                }
                                                HStack {
                                                    Text(product.address.city + ", " + product.address.state).foregroundColor(.gray).font(.caption)
                                                    Spacer()
                                                    Text(product.date.prefix(10)).foregroundColor(.gray).font(.caption)
                                                }
                                                Text(product.discription).foregroundColor(.gray).font(.caption)
                                            }
                                        }.padding().background(RoundedRectangle(cornerRadius: 10).fill(.black.opacity(0.5)))
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.padding()
                // Pop-up filter for the the products
                .popup(isPresented: $showProductFilter) {
                    BottomPopupView {
                        ScrollView {
                            VStack {
                                ZStack {
                                    Text("Available Products").foregroundColor(.white).font(.title3.bold()).padding(5)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "xmark.circle").imageScale(.large).foregroundColor(.white).onTapGesture() {
                                            showProductFilter = false
                                            showFilterPopUp = true
                                        }
                                    }
                                }
                                ForEach(productArr, id: \.self) { product in
                                    Text(product).padding(5)
                                        .frame(width: UIScreen.main.bounds.size.width * 0.9)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .background(.gray.opacity(0.5))
                                        .cornerRadius(10)
                                        .onTapGesture() {
                                            productFilter = product
                                            showProductFilter = false
                                            showFilterPopUp = true
                                            
                                            filteredProducts.removeAll()
                                            stateArr.removeAll()
                                            productArr.removeAll()
                                            productArr.append(productFilter)
                                            for product in products {
                                                if productFilter == product.brand_name {
                                                    filteredProducts.append(product)
                                                    stateArr.append(product.address.state)
                                                }
                                            }
                                            stateArr = Array(Set(stateArr))
                                        }
                                }
                            }.padding().frame(width: UIScreen.main.bounds.size.width).background(Color.black).opacity(0.9)
                        }.frame(maxHeight: UIScreen.main.bounds.size.height * 0.25).background(Color.black)
                    }
                }
                // Pop-up filter for the the states
                .popup(isPresented: $showStateFilter) {
                    BottomPopupView {
                        ScrollView {
                            VStack {
                                ZStack {
                                    Text("Available States").foregroundColor(.white).font(.title3.bold()).padding(5)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "xmark.circle").imageScale(.large).foregroundColor(.white).onTapGesture() {
                                            showStateFilter = false
                                            showFilterPopUp = true
                                        }
                                    }
                                }
                                ForEach(stateArr, id: \.self) { state in
                                    Text(state).padding(5)
                                        .frame(width: UIScreen.main.bounds.size.width * 0.9)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .background(.gray.opacity(0.5))
                                        .cornerRadius(10)
                                        .onTapGesture() {
                                            stateFilter = state
                                            showStateFilter = false
                                            showFilterPopUp = true
                                            
                                            filteredProducts = filteredProducts.filter {$0.address.state == stateFilter}
                                            
                                            cityArr.removeAll()
                                            for product in filteredProducts {
                                                if product.address.state == stateFilter {
                                                    cityArr.append(product.address.city)
                                                }
                                            }
                                        }
                                }
                            }.padding().frame(width: UIScreen.main.bounds.size.width).background(Color.black).opacity(0.9)
                        }.frame(maxHeight: UIScreen.main.bounds.size.height * 0.25).background(Color.black)
                    }
                }
                // Pop-up filter for the the cities
                .popup(isPresented: $showCityFilter) {
                    BottomPopupView {
                        ScrollView {
                            VStack {
                                ZStack {
                                    Text("Available Cities").foregroundColor(.white).font(.title3.bold()).padding(5)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "xmark.circle").imageScale(.large).foregroundColor(.white).onTapGesture() {
                                            showCityFilter = false
                                            showFilterPopUp = true
                                        }
                                    }
                                }
                                ForEach(cityArr, id: \.self) { city in
                                    Text(city).padding(5)
                                        .frame(width: UIScreen.main.bounds.size.width * 0.9)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .background(.gray.opacity(0.5))
                                        .cornerRadius(10)
                                        .onTapGesture() {
                                            cityFilter = city
                                            showCityFilter = false
                                            showFilterPopUp = true
                                            
                                            filteredProducts = filteredProducts.filter {$0.address.city == cityFilter}
                                        }
                                }
                            }.padding().frame(width: UIScreen.main.bounds.size.width).background(Color.black).opacity(0.9)
                        }.frame(maxHeight: UIScreen.main.bounds.size.height * 0.25).background(Color.black)
                    }
                }
            if showFilterPopUp {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Filters").foregroundColor(.gray.opacity(0.5))
                            
                            Spacer()
                            
                            Button(action: {
                                showFilterPopUp = false
                                if productFilter != "Products" {
                                    filterCounter += 1
                                }
                                if stateFilter != "State" {
                                    filterCounter += 1
                                }
                                if cityFilter != "City" {
                                    filterCounter += 1
                                }
                                if filterCounter > 3 {
                                    filterCounter = 3
                                }
                            }) {Image(systemName: "xmark.circle").foregroundColor(.gray.opacity(0.5))}
                        }
                       
                        ExDivider2()
                        
                        Spacer()
                        
                        HStack {
                            
                            Text(productFilter).foregroundColor(.white).font(.subheadline)
                            Spacer()
                            Image(systemName: showProductFilter ?  "arrowtriangle.down.fill" : "arrowtriangle.right.fill" ).foregroundColor(.white.opacity(0.75)).imageScale(.small).frame(width: 15, height: 15)
                        }.padding(5).background(Color.gray.opacity(0.25)).cornerRadius(5).onTapGesture() {
                            showProductFilter.toggle()
                            showFilterPopUp = false
                        }
                        
                        HStack {
                            Text(stateFilter).foregroundColor(.white).font(.subheadline)
                            Spacer()
                            Image(systemName: showStateFilter ?  "arrowtriangle.down.fill" : "arrowtriangle.right.fill").foregroundColor(.white.opacity(0.75)).imageScale(.small).frame(width: 15, height: 15)
                        }.padding(5).background(Color.gray.opacity(0.25)).cornerRadius(5).onTapGesture() {
                            showStateFilter.toggle()
                            showFilterPopUp = false
                        }
                        
                        HStack {
                            Text(cityFilter).foregroundColor(.white).font(.subheadline)
                            Spacer()
                            Image(systemName: showCityFilter ?  "arrowtriangle.down.fill" : "arrowtriangle.right.fill").foregroundColor(.white.opacity(0.75)).imageScale(.small).frame(width: 15, height: 15)
                        }.padding(5).background(Color.gray.opacity(0.25)).cornerRadius(5).onTapGesture() {
                            showCityFilter.toggle()
                            showFilterPopUp = false
                        }
                        
                        Spacer()
                       
                    }.padding()
                }.frame(width: UIScreen.main.bounds.size.width * 0.5, height: UIScreen.main.bounds.size.height * 0.25).background(RoundedRectangle(cornerRadius: 10).fill(.black))
            }
        }.onAppear() {
            // Loads the API and organizes the initial arrays upon appearance
            Api().loadData { (products) in
                self.products = products
                
                filteredProducts = products
                
                for product in products {
                    productArr.append(product.brand_name)
                    stateArr.append(product.address.state)
                    cityArr.append(product.address.city)
                }
                productArr = Array(Set(productArr))
                stateArr = Array(Set(stateArr))
                cityArr = Array(Set(cityArr))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
