//
//  FirebaseRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

protocol FirebaseRepository {
    func getApiKey() async throws -> String
}
