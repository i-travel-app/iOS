//
//  CoreDataStack.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 10.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    func preloadData() {
        let url = self.applicationDocumentsDirectory.appendingPathComponent("test.sql")
        // Load the existing database
        do {
            var g_home_url = try String(describing: (contentsOfURL: url, encoding: String.Encoding.utf8))
            print(g_home_url)
        }
        catch {
            print(error)
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            let sourceSqliteURL = Bundle.main.url(forResource: "test", withExtension: "sql")!
            let destSqliteURL = self.applicationDocumentsDirectory.appendingPathComponent("test.sql")
            do {
                try FileManager.default.copyItem(at: sourceSqliteURL, to: destSqliteURL)
            } catch {
                print(error)
            }

        }
        
    }
}
