//
//  String+Localized.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
