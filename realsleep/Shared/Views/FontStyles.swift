//
//  FontStyles.swift
//  realsleep
//
//  Created by Ar on 5/6/22.
//

import Foundation
import SwiftUI

struct TitleStyle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(.title, design: .rounded))
    }
}

struct Heading: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(.subheadline, design: .rounded))
    }
}

struct Caption: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .rounded))
    }
}


extension View {
    func styleAsTitle() -> some View {
        modifier(TitleStyle())
    }
    func styleAsHeading() -> some View {
        modifier(Heading())
    }
    func styleAsCaption() -> some View {
        modifier(Caption())
    }
}


