//
//  VehicleImageGallery.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct VehicleImageGallery: View {
    @Binding var currentImageIndex: Int
    let images: [String]
    let onBackTap: () -> Void
    let onShareTap: () -> Void

    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                TabView(selection: $currentImageIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image("bannerImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .tag(index)
                    }
                }
                .frame(height: 250)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(currentImageIndex + 1)/\(images.count)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(12)
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                    }
                }

                VStack {
                    HStack {
                        Button(action: onBackTap) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Button(action: onShareTap) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 16)

                    Spacer()
                }
            }

            VStack(spacing: 8) {
                if isExpanded {
                    // 확장된 상태: 그리드로 모든 이미지 표시
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                        ForEach(0..<images.count, id: \.self) { index in
                            ThumbnailImageView(
                                index: index,
                                currentIndex: currentImageIndex,
                                onTap: {
                                    withAnimation {
                                        currentImageIndex = index
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    // 줄이기 버튼
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 12))
                            Text("접기")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    .padding(.top, 8)
                } else {
                    // 축소된 상태: 처음 5개만 가로 스크롤로 표시
                    HStack(spacing: 8) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(0..<min(images.count, 5), id: \.self) { index in
                                    ThumbnailImageView(
                                        index: index,
                                        currentIndex: currentImageIndex,
                                        onTap: {
                                            withAnimation {
                                                currentImageIndex = index
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // +버튼 (5개 이상일 때만 표시)
                        if images.count > 5 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = true
                                }
                            }) {
                                VStack(spacing: 2) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("\(images.count - 5)")
                                        .font(.system(size: 10, weight: .medium))
                                }
                                .foregroundColor(.white)
                                .frame(width: 64, height: 48)
                                .background(Color.black.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.orange, lineWidth: 1)
                                )
                            }
                            .padding(.trailing, 16)
                        }
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}

struct ThumbnailImageView: View {
    let index: Int
    let currentIndex: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image("bannerImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 64, height: 48)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            index == currentIndex ? Color.orange : Color.white.opacity(0.2),
                            lineWidth: 2
                        )
                )
        }
    }
}

#Preview {
    VehicleImageGallery(
        currentImageIndex: .constant(0),
        images: Array(1...8).map { "test\($0)" }, // 8개 이미지로 테스트
        onBackTap: {},
        onShareTap: {}
    )
}
