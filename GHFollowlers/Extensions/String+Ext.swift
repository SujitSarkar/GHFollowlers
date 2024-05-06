//
//  String+Ext.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 7/5/24.
//

import Foundation

extension String{
    
    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ" //Get formatter from: https://www.nsdateformatter.com/
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "Format didn't match" }
        return date.convertToMonthDayYear()
    }
}
