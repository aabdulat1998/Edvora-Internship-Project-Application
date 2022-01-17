//
//  Accessory Views.swift
//  Edvora Internship Project Application
//
//  Created by Abdurakhmon Abdulatipov on 1/17/22.
//

import Foundation
import SwiftUI

// Modifies the view for the popups
struct OverlayModifier<OverlayView: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var overlayView: () -> OverlayView
    init(isPresented: Binding<Bool>, @ViewBuilder overlayView: @escaping () -> OverlayView) {
        self._isPresented = isPresented
        self.overlayView = overlayView
    }
    func body(content: Content) -> some View {
        content.overlay(isPresented ? overlayView() : nil)
    }
}

// Extension of the modified overlay view
extension View {
    func popup<OverlayView: View>(isPresented: Binding<Bool>,
                                  blurRadius: CGFloat = 3,
                                  blurAnimation: Animation? = .linear,
                                  @ViewBuilder overlayView: @escaping () -> OverlayView) -> some View {
        return blur(radius: isPresented.wrappedValue ? blurRadius : 0)
            .animation(blurAnimation)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(isPresented: isPresented, overlayView: overlayView))
    }
}

//Bottom popup view card
struct BottomPopupView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content()
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .edgesIgnoringSafeArea([.bottom])
        }
        .animation(.easeOut)
        .transition(.move(edge: .bottom))
    }
}

//Custom Divider 1
struct ExDivider: View {
    let color: Color = .gray
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: UIScreen.main.bounds.width * 0.95, height: width)
    }
}

//Custom Divider 2
struct ExDivider2: View {
    let color: Color = .gray
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: UIScreen.main.bounds.width * 0.44, height: width)
    }
}
