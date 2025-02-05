//
//  ImageLoaderProtocol.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import UIKit

protocol ImageLoadingService {
    func loadImage(from urlString: String) async throws -> UIImage
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) throws -> URLSessionDataTask?
}
