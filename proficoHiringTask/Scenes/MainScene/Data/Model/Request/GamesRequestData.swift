//
//  GamesRequestData.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Data {
    struct GamesRequest: Encodable {
        let page: Int
        let pageSize: Int
        let genres: String?
        
        enum CodingKeys: String, CodingKey {
            case page, genres
            case pageSize = "page_size"
        }
        
        init(page: Int, pageSize: Int, genres: [Int]?) {
            self.page = page
            self.pageSize = pageSize
            self.genres = genres?.map({ String($0) }).joined(separator: ",")
        }
    }
}
