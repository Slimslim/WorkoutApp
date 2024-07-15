//
//  LoginView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/12/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var username: String
    
    var body: some View {
        ProgressView()
            .task{
                await login()
            }
    }
    
    private func login() async{
        do{
            let user = try await realmApp.login(credentials: .anonymous)
            username = user.id
        } catch{
            print("Failed to login to Realm: \(error.localizedDescription)")
        }
    }
}
