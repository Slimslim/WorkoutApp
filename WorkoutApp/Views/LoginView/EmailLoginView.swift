//
//  EmailLoginView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/15/24.
//

import SwiftUI

struct EmailLoginView: View {
    
    enum Field: Hashable {
        case username
        case password
    }
    
    @Binding var username: String
    
    @State private var email = ""
    @State private var password = ""
    @State private var newUser = false
    @State private var errorMessage = ""
    @State private var inProgress = false
    
    @FocusState private var focussedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Spacer()
                    TextField("Email address", text: $email)
                        .focused($focussedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focussedField = .password
                        }
                    SecureField("Password", text: $password)
                        .focused($focussedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            userAction()
                        }
                    Button(action: {
                        newUser.toggle()
                    }) {
                        HStack {
                            Image(systemName: newUser ? "checkmark.square" : "square")
                            Text("Register new user")
                            Spacer()
                        }
                    }
                    Button(action: {
                        userAction()
                    }) {
                        Text(newUser ? "Register new user" : "Log in")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                if inProgress {ProgressView()}
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focussedField = .username
                }
            }
            .navigationBarTitle("Email Login", displayMode: .inline)
            .padding()
        }
    }
    
    func userAction() {
        errorMessage = ""
        inProgress = true
        
        Task {
            do {
                if newUser {
                    try await realmApp.emailPasswordAuth.registerUser(email: email, password: password)
                }
                let _ = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
                username = email
                inProgress = false
            } catch {
                errorMessage = error.localizedDescription
                inProgress = false
            }
        }
    }
}

struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView(username: .constant("PreviewUsername"))
    }
}
