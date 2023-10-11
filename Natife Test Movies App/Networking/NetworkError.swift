//
//  NetworkError.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

enum NetworkError: Error {
    case noData
    case noConnection
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            NSLocalizedString("No Data Available", comment: "")
        case .noConnection:
            NSLocalizedString("You are offline. Please, enable your Wi-Fi or connect using cellular data.", comment: "")
        }
    }
}
