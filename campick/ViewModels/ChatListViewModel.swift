//
//  ChatListViewModel.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation
import Alamofire


final class ChatListViewModel: ObservableObject {
    @Published var chats: [ChatList] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadChats() {
        isLoading = true
        ChatService.shared.getChatList { [weak self] (result: Result<[ChatList], AFError>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.chats = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
