//
//  Util.swift
//  CarLog
//
//  Created by t2023-m0056 on 2023/10/20.
//

import Foundation

class Util {
    static let util = Util()
    
    func toInterval(seletedDate: Int, type: componentsType) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var value = 0
        switch type {
        case .engineOil:
            value = 6 - seletedDate
        case .missionOil:
            value = 24 - seletedDate
        case .brakeOil:
            value = 24 - seletedDate
        case .brakePad:
            value = 12 - seletedDate
        case .tireRotation:
            value = 12 - seletedDate
        case .tire:
            value = 36 - seletedDate
        case .fuelFilter:
            value = 12 - seletedDate
        case .wiperBlade:
            value = 12 - seletedDate
        case .airconFilter:
            value = 12 - seletedDate
        case .insurance:
            value = 12 - seletedDate
        }
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) else { return Date() }
        return newDate
    }
    
    func toInterval(seletedDate: Int) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .month, value: -seletedDate, to: currentDate) else { return Date() }
        return newDate
    }
    
    func toInterval(seletedInsuranceDate: Int) -> (Date, Date) {
        let calendar = Calendar.current
        let currentDate = Date()
        var thisYearComponents = DateComponents()
        thisYearComponents.year = calendar.component(.year, from: currentDate)
        thisYearComponents.month = seletedInsuranceDate
        thisYearComponents.day = 1
        
        var lastYearComponents = DateComponents()
        lastYearComponents.year = calendar.component(.year, from: currentDate) - 1
        lastYearComponents.month = seletedInsuranceDate
        lastYearComponents.day = 1
        
        var nextYearComponents = DateComponents()
        nextYearComponents.year = calendar.component(.year, from: currentDate) + 1
        nextYearComponents.month = seletedInsuranceDate
        nextYearComponents.day = 1
        
        guard let thisYearDate = calendar.date(from: thisYearComponents) else { return (Date(), Date()) }
        guard let lastYearDate = calendar.date(from: lastYearComponents) else { return (Date(), Date()) }
        guard let nextYearDate = calendar.date(from: nextYearComponents) else { return (Date(), Date()) }
        
        if currentDate < thisYearDate {
            return (lastYearDate, thisYearDate)
        } else {
            return (thisYearDate, nextYearDate)
        }
    }
}
