//
//  ProfileViewViewModel.swift
//  TwitterMitter
//
//  Created by Davit Margaryan on 13.10.23.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
    
    func getFormattedDate(with date: Date) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "MMM YYYY"
        return dataFormatter.string(from: date)
    }
}
