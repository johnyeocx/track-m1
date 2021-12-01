//
//  Payments.swift
//  Track
//
//  Created by John Yeo on 20/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import SQLite3

struct Payment {
    var id: Int
    var name: String
    var amount: Float
    var reason: String
    var date: String
}

class PaymentManager {
    var database: OpaquePointer!
    
    static let main = PaymentManager()
    
    private init () {
    }
    
    func connect() {
        do{
            if database != nil {
                return
            }
            
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("payments.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS payments(name TEXT, amount DOUBLE, reason TEXT, date TEXT)", nil, nil, nil) == SQLITE_OK {
                    
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
    
    func create(payment: Payment) -> Int{
        connect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO payments (name, amount, reason, date) VALUES (?, ?, ?, ?)", -1, &statement, nil) != SQLITE_OK {
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
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getLastRowId() -> Int {
        connect()
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllPayments() -> [Payment] {
        connect()
        
        var statement: OpaquePointer!
        var result: [Payment] = []
        
        if sqlite3_prepare_v2(database, "SELECT rowid, name, amount, reason, date FROM payments", -2, &statement, nil) != SQLITE_OK {
            print("error creating select")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Payment(id: Int(sqlite3_column_int(statement, 0)), name: String(cString: sqlite3_column_text(statement, 1)), amount: Float(sqlite3_column_double(statement, 2)), reason: String(cString: sqlite3_column_text(statement, 3)), date: String(cString: sqlite3_column_text(statement, 4)) ))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func save(payment: Payment) {
        connect ()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE payments SET name = ?, amount = ?, reason = ?, date = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
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
    
    func delete(payment: Payment) {
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM payments WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("error deleting payment")
        }
        
        sqlite3_bind_int(statement, 1, Int32(payment.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("Error running update")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM payments", -1, &statement, nil) != SQLITE_OK {
            print("error deleting note")
        }
            if sqlite3_step(statement) != SQLITE_DONE {
                print ("Error running update")
            }
            sqlite3_finalize(statement)
    }
}



