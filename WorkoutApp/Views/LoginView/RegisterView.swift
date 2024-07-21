//
//  RegisterView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/16/24.
//

import SwiftUI
import RealmSwift

struct RegisterView: View {
    
    enum Field: Hashable {
        case username
        case email
        case password
        case confirmPassword
    }
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var inProgress = false
    
    @FocusState private var focussedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Spacer()
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .focused($focussedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focussedField = .email
                        }
                    TextField("Email address", text: $email)
                        .autocapitalization(.none)
                        .focused($focussedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focussedField = .password
                        }
                    SecureField("Password", text: $password)
                        .focused($focussedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focussedField = .confirmPassword
                        }
                    SecureField("Confirm Password", text: $confirmPassword)
                        .focused($focussedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit {
                            registerUser()
                        }
                    Button(action: {
                        registerUser()
                    }) {
                        Text("Create Account")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                if inProgress { ProgressView() }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focussedField = .username
                }
            }
            .navigationBarTitle("Register", displayMode: .inline)
            .padding()
        }
    }
    
    func registerUser() {
        errorMessage = ""
        inProgress = true
        
        // Check if passwords match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            inProgress = false
            return
        }
        
        Task {
            do {
                // Check if username already exists in the database
                let usernameExists = try await checkUsernameExists(username)
                guard !usernameExists else {
                    errorMessage = "Username already exists"
                    inProgress = false
                    return
                }
                
                // Register the user with email and password
                try await realmApp.emailPasswordAuth.registerUser(email: email, password: password)
                
//                // Login the user to get their user ID
//                let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
//                
//                // Prepare user data for the function
//                let userData = ["username": AnyBSON(username), "email": AnyBSON(email)]
////                let userData: Document = ["username": AnyBSON(username), "email": AnyBSON(email)]
//                                
//                // Call the function to create user data
//                let result = try await user.functions.createNewUser([AnyBSON(userData)])
//                
//                // Check the result of the function
//                if let resultDict = result.documentValue?.reduce(into: [String: Any](), { $0[$1.key] = $1.value }), resultDict["status"] as? String == "success" {
//                    // Handle successful registration
//                    inProgress = false
//                    // Redirect to login page or perform other actions
//                } else {
//                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create user data"])
//                }
                
            } catch {
                print("Error during registration: \(error)")
                errorMessage = error.localizedDescription
                inProgress = false
            }
        }
    }
    
    // Example function to check if username exists
    func checkUsernameExists(_ username: String) async throws -> Bool {
        let userCollection = realmApp.currentUser?.mongoClient("mongodb-atlas").database(named: "WorkoutAppDB").collection(withName: "User")
        let result = try await userCollection?.findOneDocument(filter: ["username": AnyBSON(username)])
        return result != nil
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

