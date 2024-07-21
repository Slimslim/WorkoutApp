//
//  ProductsView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/14/24.
//

import SwiftUI
import RealmSwift

struct ProductsView: View {
        let username: String
        let products = ["MongoDB", "Atlas", "Realm", "Charts", "Compass"]

        var body: some View {
            NavigationStack{
                List {
                    if let realmUser = realmApp.currentUser {
                        ForEach(products, id: \.self) { product in
                            NavigationLink (destination: TicketsView(username: username, product: product)
                                            /// Pass the configuration of the user and server informaiton in order to do the fetch on that next page
                                .environment(\.realmConfiguration, realmUser.flexibleSyncConfiguration())){
                                    Text(product)
                                }
                            
                        }
                    }
                }
            }
        }
    }
