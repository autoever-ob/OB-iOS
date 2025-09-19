//
//  NoPasteSecureField.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import SwiftUI
import UIKit

final class NoPasteTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) || action == #selector(copy(_:)) || action == #selector(cut(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

struct NoPasteSecureFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var isSecure: Bool

    func makeUIView(context: Context) -> NoPasteTextField {
        let tf = NoPasteTextField()
        tf.isSecureTextEntry = isSecure
        tf.textContentType = .password
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .default
        tf.textColor = UIColor.white
        tf.tintColor = UIColor(Color(AppColors.brandOrange))
        tf.font = UIFont.preferredFont(forTextStyle: .body)
        tf.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        return tf
    }

    func updateUIView(_ uiView: NoPasteTextField, context: Context) {
        uiView.text = text
        if uiView.isSecureTextEntry != isSecure {
            uiView.isSecureTextEntry = isSecure
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    class Coordinator: NSObject {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        @objc func changed(_ sender: UITextField) { text.wrappedValue = sender.text ?? "" }
    }
}

struct NoPasteSecureField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String?
    @State private var isRevealed = false

    init(text: Binding<String>, placeholder: String, systemImage: String? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.leading, 4)
                }
                NoPasteSecureFieldRepresentable(text: $text, isSecure: !isRevealed)
                    .frame(height: 22)
            }

            Button(action: { isRevealed.toggle() }) {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 24)
            }

            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 24, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

