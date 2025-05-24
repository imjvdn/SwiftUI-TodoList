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
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Todo List")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text(message)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Color(UIColor.systemBackground)
                    .opacity(0.98)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 8)
            .padding(.top, 4) // Small gap from the very top edge
            
            Spacer() // Push notification to the top
        }
        .transition(.move(edge: .top))
    }
}
