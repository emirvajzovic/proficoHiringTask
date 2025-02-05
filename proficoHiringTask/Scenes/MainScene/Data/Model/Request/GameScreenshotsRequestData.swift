//
//  GameScreenshotsRequestData.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Data {
    struct GameScreenshotsRequest: Encodable {
        let id: Int
        let count: Int
        
        enum CodingKeys: String, CodingKey {
            case count
        }
        
        init(id: Int, count: Int) {
            self.id = id
            self.count = count
        }
    }
}
