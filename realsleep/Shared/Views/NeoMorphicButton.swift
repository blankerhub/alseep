//
//  NeoMorphicButton.swift
//  realsleep
//
//  Created by Ar on 5/5/22.
//

import SwiftUI

struct NeoButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(configuration.isPressed ? Color.neuBackgroundPressed : Color.neuBackground)
                )
                .shadow(color: .dropShadow, radius: 3, x: 3, y: 3)
                .shadow(color: .dropLight, radius: 3, x: -3, y: -3)
                //.clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundColor(Color.mainLight)
                .opacity(configuration.isPressed ? 30 : 100)
    }
    
}

struct NeoButtonStyleWithoutHover: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.neuBackground)
                )
                .shadow(color: .dropShadow, radius: 3, x: 3, y: 3)
                .shadow(color: .dropLight, radius: 3, x: -3, y: -3)
                //.clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundColor(.primary)
                .opacity(configuration.isPressed ? 30 : 100)
    }
    
}

extension Button {
    func styleAsNeo(radius: CGFloat = 15) -> some View {
        self.padding(10)
            .background(
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.neuBackground)
        )
        .shadow(color: .dropShadow, radius: 3, x: 3, y: 3)
        .shadow(color: .dropLight, radius: 3, x: -3, y: -3)
        //.clipShape(RoundedRectangle(cornerRadius: 15))
        .foregroundColor(.primary)
        
    }
}

struct NeoMorphicButton: View {
    @State var action: () -> Void
    @State var text: String
    var body: some View {
        ZStack{
            Button(action: onClicked){Text(text)}.buttonStyle(NeoButtonStyle())
        }
    }
    func onClicked(){
        
    }
}

struct NeoMorphicButton_Previews: PreviewProvider {
    static var previews: some View {
        NeoMorphicButton(action: {}, text: "some large text")
    }
}
