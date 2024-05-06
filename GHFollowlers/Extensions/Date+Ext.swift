//
//  Date+Ext.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 7/5/24.
//

import Foundation

extension Date {
    
    func convertToMonthDayYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" //Get formatter from: https://www.nsdateformatter.com/
        return dateFormatter.string(from: self)
    }
}
