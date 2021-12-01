//
//  HistoryPayments.swift
//  Track
//
//  Created by John Yeo on 3/8/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import SQLite3

class HistoryPaymentManager {
    
    var historyDatabase: OpaquePointer!
    
    static let main = HistoryPaymentManager()
    
    func historyConnect() {
        do{
            if historyDatabase != nil {
                return
            }
            
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("historyPayments.sqlite3")
            
            if sqlite3_open(databaseURL.path, &historyDatabase) == SQLITE_OK {
                if sqlite3_exec(historyDatabase, "CREATE TABLE IF NOT EXISTS historyPayments(name TEXT, amount DOUBLE, reason TEXT, date TEXT)", nil, nil, nil) == SQLITE_OK {
                    
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
    
    func historyCreate(payment: Payment) -> Int{
        historyConnect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(historyDatabase, "INSERT INTO historyPayments(name, amount, reason, date) VALUES (?, ?, ?, ?)", -1, &statement, nil) != SQLITE_OK {
            print("could not create query")
            return -1
        }
        
        sqlite3_bind_text(statement, 4, NSString(string: payment.date).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, NSString(string: payment.reason).utf8String, -1, nil)
        sqlite3_bind_double(statement, 2, Double(payment.amount))
        sqlite3_bind_text(statement, 1, NSString(string: payment.name).utf8String, -1, nil)
        
        
        if sqlite3_step(statement) != SQLITE_DONE {
                print("could not insert payment")
        }
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(historyDatabase))
    }
    
    func historyGetLastRowId() -> Int {
        historyConnect()
        return Int(sqlite3_last_insert_rowid(historyDatabase))
    }
    
    func historyGetAllPayments() -> [Payment] {
        historyConnect()
        
        var statement: OpaquePointer!
        var result: [Payment] = []
        
        if sqlite3_prepare_v2(historyDatabase, "SELECT rowid, name, amount, reason, date FROM historyPayments", -2, &statement, nil) != SQLITE_OK {
            print("error creating select")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Payment(id: Int(sqlite3_column_int(statement, 0)), name: String(cString: sqlite3_column_text(statement, 1)), amount: Float(sqlite3_column_double(statement, 2)), reason: String(cString: sqlite3_column_text(statement, 3)), date: String(cString: sqlite3_column_text(statement, 4)) ))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func historySave(payment: Payment) {
        historyConnect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(historyDatabase, "UPDATE historyPayments SET name = ?, amount = ?, reason = ?, date = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: payment.name).utf8String, -1, nil)
        sqlite3_bind_double(statement, 2, Double(payment.amount))
        sqlite3_bind_text(statement, 3, NSString(string: payment.reason).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, NSString(string: payment.date).utf8String, -1, nil)
        sqlite3_bind_double(statement, 5, Double(payment.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func historyDelete(payment: Payment) {
        historyConnect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(historyDatabase, "DELETE FROM historyPayments WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("error deleting note")
        }
        
        sqlite3_bind_int(statement, 1, Int32(payment.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func historyDeleteAll() {
        
        historyConnect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(historyDatabase, "DELETE FROM historyPayments", -1, &statement, nil) != SQLITE_OK {
            print("error deleting note")
        }
            if sqlite3_step(statement) != SQLITE_DONE {
                print ("Error running update")
            }
            sqlite3_finalize(statement)
    }
}
