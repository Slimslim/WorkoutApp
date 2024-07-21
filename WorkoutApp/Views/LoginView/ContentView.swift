//
//  ContentView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var username = ""
    
    var body: some View {
        NavigationView{
            if username == "" {
//                LoginView(username: $username)
                MainTabView(username: $username)
            } else {
                MainTabView(username: $username)
            }
        }
    }
}
