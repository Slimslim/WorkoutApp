//
//  SettingsView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var username: String
    
    var body: some View {
        NavigationView {
            Text("Settings")
                .navigationTitle("Settings")
                .navigationBarItems(trailing: LogoutButtonView(username: $username))
        }
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}

