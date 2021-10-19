//
//  AppHelper.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/18/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

final class AppHelper {
    static func formatDate(dateString: String?, formatString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_us")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd'T'HH:mm:ss")
        guard let date = dateFormatter.date(from: dateString ?? "") else { return dateString }

        dateFormatter.setLocalizedDateFormatFromTemplate(formatString)
        return dateFormatter.string(from: date)
    }
}
