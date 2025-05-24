//
//  NotificationBanner.swift
//  TodoList
//
//  Created by Jadan Morrow on 5/23/25.
//

import SwiftUI

struct NotificationBanner: View {
    let message: String
    let icon: String
    let color: Color
    
    // Animation state for pulsing effect
    @State private var isPulsing = false
    
    var body: some View {
        // iOS-style notification banner that slides down from the top
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Todo List")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.primary)
                        .opacity(0.9)
                    
                    Text(message)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .scaleEffect(isPulsing ? 1.02 : 1.0)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
            .background(
                ZStack {
                    // Vibrant background with slight gradient
                    LinearGradient(gradient: Gradient(colors: [
                        Color(UIColor.systemGray6),
                        Color(UIColor.systemGray5)
                    ]), startPoint: .top, endPoint: .bottom)
                    
                    // Frosted glass effect
                    Color.white.opacity(0.3)
                        .background(
                            Color(UIColor.systemBackground)
                                .opacity(0.7)
                        )
                        .blur(radius: 0.5)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 8)
            .padding(.top, 4) // Small gap from the very top edge
            
            Spacer() // Push notification to the top
        }
        .transition(.move(edge: .top))
    }
}
