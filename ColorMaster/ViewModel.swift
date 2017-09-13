//
//  ViewModel.swift
//  ColorMaster
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm dd/MM/yy"
        return formatter
    }()
}

struct LogEntry: CustomStringConvertible {
    let name: String
    let date: Date
    let message: String
    
    var description: String {
        return "\(Date.formatter.string(from:date)) - \(name): \(message)"
    }
}

struct ViewModel {
    var onDisplayNameChanged: ((String?) -> Void)?
    var onPeersNamesChanged: (([String]) -> Void)?
    var onLogEntryWasAdded: (([LogEntry]) -> Void)?
    var displayName: String? {
        didSet {
            onDisplayNameChanged?(displayName)
        }
    }
    var peersNames = [String]() {
        didSet {
            onPeersNamesChanged?(peersNames)
        }
    }
    private(set) var logEntries = [LogEntry]()
    
    mutating func addLog(_ log: LogEntry) {
        logEntries.append(log)
        onLogEntryWasAdded?(logEntries)
    }
}
