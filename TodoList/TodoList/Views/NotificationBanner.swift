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
    @Binding var isShowing: Bool
    
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
                
                Button(action: {
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .onAppear {
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    if isShowing {
                        isShowing = false
                    }
                }
            }
        }
    }
}
