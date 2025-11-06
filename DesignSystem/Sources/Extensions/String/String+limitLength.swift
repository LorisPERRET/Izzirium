//
//  String+limitLength.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 27/06/2025.
//

import Foundation

extension String {

    func limitLength(_ maxLength: Int) -> String {
        guard self.count > maxLength else {
            return self
        }

        return String(self.dropLast(self.count - maxLength))
    }
}
