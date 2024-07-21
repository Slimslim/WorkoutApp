//
//  CustomViews.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/16/24.
//

import SwiftUI

struct CustomViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct CustomSecureField: View {
//    var placeHolder: String
//    var imageName: String
//    var bColor: Color
//    var tOpacity: Double
//    @Binding var value: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 20, height: 20)
//                .padding(.leading, 20)
//                .foregroundColor(bColor.opacity(tOpacity))
//
//            ZStack(alignment: .leading) {
//                if value.isEmpty {
//                    Text(placeHolder)
//                        .foregroundColor(bColor.opacity(tOpacity))
//                        .padding(.leading, 12)
//                        .font(.system(size: 20))
//                }
//                if placeHolder == "Password" || placeHolder == "Confirm Password" {
//                    SecureField("", text: $value)
//                        .padding(.leading, 12)
//                        .font(.system(size: 20))
//                        .frame(height: 45)
//                } else {
//                    TextField("", text: $value)
//                        .padding(.leading, 12)
//                        .font(.system(size: 20))
//                        .frame(height: 45)
//                        .foregroundColor(bColor)
//                }
//            }
//        }
//        .overlay(
//            Divider()
//                .background(bColor.opacity(tOpacity))
//                .padding(.horizontal, 20),
//            alignment: .bottom
//        )
//    }
//}

struct CustomButton: View {
    var title: String
    var bgColor: Color
    
    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 58)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(bgColor)
            .cornerRadius(15)
    }
}

#Preview {
    CustomViews()
}
