//
//  LoginView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/12/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @State private var showEmailLogin = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        VStack{
            Text("Log In")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            VStack(spacing: 30){
                CustomSecureField(placeHolder: "Email", imageName: "envelope", bColor: .black , tOpacity: 0.6, value: $email)
                CustomSecureField(placeHolder: "Password", imageName: "lock", bColor: .black , tOpacity: 0.6, value: $password)
            }
            VStack (alignment: .trailing){
                
                Button (action: {
//                    login()
                }, label: {
                    CustomButton(title: "Login", bgColor: .teal)
                })
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(10)
            
            VStack{
                SocialLoginButton(logo: "apple.logo", text: "Sign in with Apple")
            }
            Spacer()
            HStack{
                Text("Don't have an account?")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                
                Button(action: {}, label: {
                    Text("SIGN UP")
                        .font(.system(size: 18))
                        .foregroundColor(.indigo)
                        .fontWeight(.bold)
                })
            }
            .frame(height: 63)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(.teal)
            .ignoresSafeArea()
            
            
//            SocialLoginButton(logo: "apple.logo", text: "Sign in with Apple")
//            NavigationLink(destination: EmailLoginView(username: $username)) {
//                SocialLoginButton(logo: "envelope", text: "Login with Email")
//            }
//            Spacer()
//            NavigationLink("Create an account", destination: RegisterView())
        }
        .edgesIgnoringSafeArea(.bottom)
        
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
    
    
    struct SocialLoginButton: View {
        var logo: String
        var text: String
        var body: some View {
            HStack{
                Image(systemName: logo)
                    .padding(.horizontal)
                Spacer()
                Text(text)
                    .font(.title2)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(50.0)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
        }
    }
}
