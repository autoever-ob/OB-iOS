//
//  CarListFirebaseView.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//

import SwiftUI

struct CarListView: View {
    @StateObject private var viewModel = CarViewModel()
        
    var body: some View {
        NavigationView {
            List(viewModel.cars) { car in
                VStack(alignment: .leading) {
                    Text("\(car.brand) \(car.model)")
                        .font(.headline)
                    Text("Year: \(car.year)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Cars")
        }
    }
}

#Preview {
    CarListView()
}
