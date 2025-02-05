//
//  StandardFirebaseRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

import FirebaseFirestore

final class StandardFirebaseRepository: FirebaseRepository {
    private enum Collection: String {
        case apiKeys
    }
    
    private enum Document: String {
        case production
    }
    
    private enum Field: String {
        case key
    }
    
    private let database = Firestore.firestore()
    
    func getApiKey() async throws -> String {
        let documentReference = database
            .collection(Collection.apiKeys.rawValue)
            .document(Document.production.rawValue)
        
        let document = try await documentReference.getDocument()
        guard let key = document.get(Field.key.rawValue) as? String, key.isEmpty == false else {
            throw FirebaseError.failedToReadData
        }
        
        return key
    }
}

extension StandardFirebaseRepository {
    enum FirebaseError: Error {
        case failedToReadData
    }
}
