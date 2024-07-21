//
//  LogoutButtonView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/15/24.
//

import SwiftUI
import RealmSwift

struct LogoutButtonView: View {
    
    @Binding var username: String
    @State private var isConfirming = false
    
    var body: some View {
        Button("Logout"){
            isConfirming = true
        }
        .confirmationDialog("Are you sure you want to logout?", isPresented: $isConfirming) {
            Button("Confirm Logout", role: .destructive){ logout()}
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func logout(){
        Task {
            do {
                try await realmApp.currentUser?.logOut()
                username = ""
            } catch {
                print("Failed to logout: \(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    LogoutButtonView()
//}
