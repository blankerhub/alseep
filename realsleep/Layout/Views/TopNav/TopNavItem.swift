//
//  TopNavItem.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

struct TopNavItem: View {
    var itemText: String
    var isActive: Bool
    var body: some View {
        if isActive {
            VStack(spacing: 0){
                Text(itemText)
                    .font(.system(.title3,design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black)
                    .frame(width: 14, height: 4)
            }

        }
        else{
            VStack(spacing: 0){
                Text(itemText)
                    .fontWeight(.medium)
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(Color.black)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black)
                    .frame(width: 14, height: 4)
                    .opacity(0)
            }.opacity(0.3)

        }
    }
}

struct TopNavItem_Previews: PreviewProvider {
    static var previews: some View {
        TopNavItem(itemText: "Test", isActive: true)
    }
}
