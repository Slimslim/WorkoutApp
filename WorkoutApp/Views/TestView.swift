//
//  TestView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/20/24.
//

import SwiftUI
import AVFoundation

struct TestApp: App {
    init() {
        configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            TestView()
        }
    }

    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}

struct TestView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 30) {
            CustomSecureField(placeHolder: "Email", imageName: "envelope", bColor: .black, tOpacity: 0.6, value: $email)
            CustomSecureField(placeHolder: "Password", imageName: "lock", bColor: .black, tOpacity: 0.6, value: $password)
        }
        .padding()
    }
}

struct CustomSecureField: View {
    var placeHolder: String
    var imageName: String
    var bColor: Color
    var tOpacity: Double
    @Binding var value: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(.leading, 20)
                .foregroundColor(bColor.opacity(tOpacity))

            ZStack(alignment: .leading) {
                if value.isEmpty {
                    Text(placeHolder)
                        .foregroundColor(bColor.opacity(tOpacity))
                        .padding(.leading, 12)
                        .font(.system(size: 20))
                }
                if placeHolder == "Password" || placeHolder == "Confirm Password" {
                    SecureField("", text: $value)
                        .padding(.leading, 12)
                        .font(.system(size: 20))
                        .frame(height: 45)
                } else {
                    TextField("", text: $value)
                        .padding(.leading, 12)
                        .font(.system(size: 20))
                        .frame(height: 45)
                        .foregroundColor(bColor)
                }
            }
        }
        .overlay(
            Divider()
                .background(bColor.opacity(tOpacity))
                .padding(.horizontal, 20),
            alignment: .bottom
        )
    }
}


