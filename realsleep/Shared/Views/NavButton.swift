//
//  NavButton.swift
//  realsleep
//
//  Created by Ar on 5/6/22.
//

import SwiftUI

struct NavButton: View {
    var body: some View {
        ZStack{
            Button(action:{}){
                Image(systemName: "chevron.forward")
            }.padding(10)
                .background(
                    Circle()
                        .fill(Color.neuBackground)
                )
                .shadow(color: .dropShadow, radius: 3, x: 3, y: 3)
                .shadow(color: .dropLight, radius: 3, x: -3, y: -3)
                //.clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundColor(.primary)
        }
        
    }
}

struct NavButton_Previews: PreviewProvider {
    static var previews: some View {
        NavButton()
    }
}
