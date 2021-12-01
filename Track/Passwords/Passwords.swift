//
//  Passwords.swift
//  Track
//
//  Created by John Yeo on 25/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import SQLite3

struct Password {
    var id: Int
    var site: String
    var username: String
    var password: String
    var date: String
}

class PasswordManager {
    var database: OpaquePointer!
    
    static let main = PasswordManager()
    
    private init () {
    }
    
    func connect() {
        do{
            if database != nil {
                return
            }
            
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("passwords.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS passwords(site TEXT, username TEXT, password TEXT, date TEXT)", nil, nil, nil) == SQLITE_OK {
                    
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
    
    func create(password: Password) -> Int{
        connect ()

        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO passwords (site, username, password, date) VALUES (?, ?, ?, ?)", -1, &statement, nil) != SQLITE_OK {
            print("could not create query")
            return -1
        }
        
        sqlite3_bind_text(statement, 4, NSString(string: password.date).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, NSString(string: password.password).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: password.username).utf8String, -1, nil)
        sqlite3_bind_text(statement, 1, NSString(string: password.site).utf8String, -1, nil)
        
        
        if sqlite3_step(statement) != SQLITE_DONE {
                print("could not insert password")
        }
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getLastRowId() -> Int {
        connect()
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllPasswords() -> [Password] {
        connect()
        
        var statement: OpaquePointer!
        var result: [Password] = []
        
        if sqlite3_prepare_v2(database, "SELECT rowid, site, username, password, date FROM passwords", -2, &statement, nil) != SQLITE_OK {
            print("error creating select")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Password(id: Int(sqlite3_column_int(statement, 0)),
                                   site: String(cString: sqlite3_column_text(statement, 1)),
                                   username: String(cString: sqlite3_column_text(statement, 2)),
                                   password: String(cString: sqlite3_column_text(statement, 3)),
                                   date: String(cString: sqlite3_column_text(statement, 4))))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func save(password: Password) {
        connect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE passwords SET site = ?, username = ?, password = ?, date = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: password.site).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: password.username).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, NSString(string: password.password).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, NSString(string: password.date).utf8String, -1, nil)
        sqlite3_bind_double(statement, 5, Double(password.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func delete(password: Password) {
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM passwords WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("error deleting password")
        }
        
        sqlite3_bind_int(statement, 1, Int32(password.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM payments", -1, &statement, nil) != SQLITE_OK {
            print("error deleting password database")
        }
            if sqlite3_step(statement) != SQLITE_DONE {
                print ("Error running update")
            }
            sqlite3_finalize(statement)
    }
}
