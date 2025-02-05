//
//  APIKeyAdapter.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Foundation

struct APIKeyAdapter: RequestAdapter {
    private enum ParameterKeys: String {
        case key
    }
    
    @Injected private var keychainRepository: KeychainRepository

    func adapt(_ request: inout URLRequest) {
        guard
            let url = request.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let key = keychainRepository.getApiKey()
        else {
            return
        }
        
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(.init(name: ParameterKeys.key.rawValue, value: key))
        urlComponents.queryItems = queryItems
                
        request.url = urlComponents.url
    }
}
