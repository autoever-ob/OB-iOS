//
//  SwiftUIView.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI

struct ChatHeader: View {
    let seller: ChatSeller
    var onBack: () -> Void
    var onCall: () -> Void
    let vehicle: ChatVehicle
    
    var body: some View {
        HStack {
            Button(action: { onBack() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Image("testImage1")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(seller.name)
                    .foregroundColor(.white)
                    .font(.headline)
                HStack {
                    Circle()
                        .fill(seller.isOnline ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    Text(seller.isOnline ? "온라인" : formatTime(seller.lastSeen ?? Date()))
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button { onCall() } label: {
                    Image(systemName: "phone")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(URL(string: "tel://\(seller.phoneNumber)") == nil)
            }
        }
        .padding()
        .background(AppColors.brandBackground)
        HStack {
            Image("testImage1")
                .resizable()
                .frame(width: 60, height: 45)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.status)
                    .font(.system(size: 11, weight: .heavy))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Text(vehicle.title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .heavy))
                    .lineLimit(1)
                
                Text("\(vehicle.price)만원")
                    .foregroundColor(.orange)
                    .font(.system(size: 12, weight: .bold))
                    .bold()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding([.horizontal, .bottom])
        .background(
            AppColors.brandBackground
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1),
                    alignment: .bottom
                )
        )
//        .overlay(
//            Rectangle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(height: 1),
//            alignment: .bottom
//        )
        
        
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}



