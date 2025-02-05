//
//  Environment.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

enum Environment {
    case production
    
    var baseUrl: String {
        switch self {
        case .production:
            return "https://api.rawg.io/api"
        }
    }
}
