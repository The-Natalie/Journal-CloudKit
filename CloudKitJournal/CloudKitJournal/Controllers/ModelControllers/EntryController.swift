//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Natalie Hall on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class EntryController {
    
    // MARK: - SOT
    var entries: [Entry] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    static let shared = EntryController()
    
    // MARK: - CRUD
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        
        publicDB.save(entryRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Saved entry successfully")
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping (Result<[Entry], EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordsUnwrapped = records else { return completion(.failure(.couldNotUnwrap)) }
            print("Records have been fetched successfully")
            
            let entries = recordsUnwrapped.compactMap({ Entry(ckRecord: $0) })
            self.entries = entries
            completion(.success(entries))
        }
    }
}  // End of Class
