//
//  KeychainRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

protocol KeychainRepository {
    func store(apiKey: String)
    func getApiKey() -> String?
    func deleteApiKey()
}
