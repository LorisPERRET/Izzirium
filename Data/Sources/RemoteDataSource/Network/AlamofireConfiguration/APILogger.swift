//
//  APILogger.swift
//  Data
//
//  Created by Thibaut Schmitt on 08/03/2024.
//

import Alamofire
import Foundation
import OSLog

final class APILogger: EventMonitor {

    // MARK: - Properties

    let logger = Logger(category: APILogger.self)

    // MARK: - EventMonitor

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let httpResponse = dataTask.response as? HTTPURLResponse else {
            logger.warning("Did receive URLResponse but it is not a HTTPURLResponse")
            return
        }

        // Log received data
        logger.debug(
            """
            \(dataTask.currentRequest?.httpMethod ?? "-") \(httpResponse.statusCode): \(httpResponse.url?.absoluteString ?? "-")
            ⚡️ Data: \(String(decoding: data, as: UTF8.self))
            """
        )
    }

    func request(
        _ request: Alamofire.Request,
        didCreateURLRequest urlRequest: URLRequest
    ) {
#if DEBUG
        // Log curl command for debugging purposes
        request.cURLDescription { [weak self] curl in
            self?.logger.debug("📡 \(curl)")
        }
#endif
    }
}
