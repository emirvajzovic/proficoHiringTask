//
//  RequestAdapterProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import Foundation

protocol RequestAdapter {
    func adapt(_ request: inout URLRequest)
}
