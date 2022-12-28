//
//  ExampleApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-23.
//

import Foundation
import SwiftyDropbox
import SwiftUI

//@main
struct ExampleApp: App {
    
    let persistenceController = PersistenceController.shared

    init() {
        DropboxClientsManager.setupWithAppKey("8w6d3q89dy1uea1")
    }

    var body: some Scene {
        WindowGroup {
            SelectableList().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
