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
    
    // Animation state
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = -20
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 24))
                
                Text(message)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
        .opacity(opacity)
        .offset(y: offset)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                opacity = 1
                offset = 0
            }
        }
        .transition(.asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        ))
    }
}
