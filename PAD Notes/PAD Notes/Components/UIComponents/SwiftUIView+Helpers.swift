//
//  SwiftUIView.swift
//  DiscoverDNS
//
//  Created by Phan Anh Duy on 10/12/2023.
//

import SwiftUI

struct ViewLoading : View {
    var body: some View {
//        return ProgressView().foregroundColor(.blue)
        return ProgressView()
            .scaleEffect(2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.5))
    }
}
