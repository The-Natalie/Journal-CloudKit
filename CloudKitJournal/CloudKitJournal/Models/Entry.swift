//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Natalie Hall on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
    static let RecordTypeKey = "Entry"
}

class Entry {
    
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}  // End of Class


extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
              let body = ckRecord[EntryConstants.BodyKey] as? String,
              let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date
        else { return nil }
        
        self.init(title: title, body: body, timestamp: timestamp)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordTypeKey, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryConstants.TitleKey : entry.title,
            EntryConstants.BodyKey : entry.body,
            EntryConstants.TimestampKey : entry.timestamp,
        ])
    }
}
