//
//  buttonView.swift
//  Nano2
//
//  Created by Audriella Ruth Jim  on 21/05/23.
//

import SwiftUI

struct buttonView: View {
    var imageName: String
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            }
        }
}

struct buttonView_Previews: PreviewProvider {
    static var previews: some View {
        buttonView()
    }
}
