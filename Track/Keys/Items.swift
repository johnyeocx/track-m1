//
//  Items.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import Foundation
import SQLite3

struct Item {
    var id: Int
    var item: String
    var location: String
    var others: String
    var date: String
}

class ItemManager {
    var database: OpaquePointer!
    
    static let main = ItemManager()
    
    private init () {
    }
    
    func connect() {
        do{
            if database != nil {
                return
            }
            
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("items.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS items(item TEXT, location TEXT, others TEXT, date TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                }
                else {
                    print("could not create table")
                }
            }
            else {
                print ("could not connect")
            }
        }
        catch let error {
            print("could not find \(error)")
        }
    }
    
    func create(item: Item) -> Int{
        connect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO items (item, location, others, date) VALUES (?, ?, ?, ?)", -1, &statement, nil) != SQLITE_OK {
            print("could not create query")
            return -1
        }
        
        sqlite3_bind_text(statement, 4, NSString(string: item.date).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, NSString(string: item.others).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: item.location).utf8String, -1, nil)
        sqlite3_bind_text(statement, 1, NSString(string: item.item).utf8String, -1, nil)
        
        
        if sqlite3_step(statement) != SQLITE_DONE {
                print("could not insert payment")
        }
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getLastRowId() -> Int {
        connect()
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllItems() -> [Item] {
        connect()
        
        var statement: OpaquePointer!
        var result: [Item] = []
        
        if sqlite3_prepare_v2(database, "SELECT rowid, item, location, others, date FROM items", -2, &statement, nil) != SQLITE_OK {
            print("error creating select")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Item(id: Int(sqlite3_column_int(statement, 0)),
                               item: String(cString: sqlite3_column_text(statement, 1)),
                               location: String(cString: sqlite3_column_text(statement, 2)),
                               others: String(cString: sqlite3_column_text(statement, 3)),
                               date: String(cString: sqlite3_column_text(statement, 4))))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func save(item: Item) {
        connect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE items SET item = ?, location = ?, others = ?, date = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: item.item).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: item.location).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, NSString(string: item.others).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, NSString(string: item.date).utf8String, -1, nil)
        
        sqlite3_bind_double(statement, 5, Double(item.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func delete(item: Item) {
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM items WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("error deleting item")
        }
        
        sqlite3_bind_int(statement, 1, Int32(item.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM payments", -1, &statement, nil) != SQLITE_OK {
            print("error deleting item")
        }
            if sqlite3_step(statement) != SQLITE_DONE {
                print ("Error running update")
            }
            sqlite3_finalize(statement)
    }
}
