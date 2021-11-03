//
//  DbService.swift
//  sqlite
//
//  Created by Nickolay Truhin on 03.11.2021.
//

import Foundation
import SQLite3

class DbServiceSingleton {
    static let shared = DbServiceSingleton()
    
    var db: OpaquePointer?

    init() {
        let path = Bundle.main.path(forResource: "db", ofType: "db")
        if sqlite3_open(path, &db) == SQLITE_OK {
            debugPrint("Cool.")
        } else {
            fatalError("Oops db not opened")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }

    func query(_ queryStatementString: String) -> [[String: String]] {
        var queryStatement: OpaquePointer?
        
        var res = [[String: String]]()
        
        if sqlite3_prepare_v2(
            db,
            queryStatementString,
            -1,
            &queryStatement,
            nil
        ) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                
                res.append([String: String](
                    uniqueKeysWithValues: (0..<sqlite3_column_count(queryStatement))
                    .compactMap {
                        guard let cname = sqlite3_column_name(queryStatement, $0),
                              let cval = sqlite3_column_text(queryStatement, $0) else { return nil }
                        return (String(cString: cname), String(cString: cval))
                    })
                                                                )
                
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        
        return res
    }
}
