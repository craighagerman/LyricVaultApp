//
//  LyricVaultApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

//
//  DBDirListApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-22.
//

import SwiftyDropbox
import SwiftUI


@main
struct LyricVaultApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    init() {
        DropboxClientsManager.setupWithAppKey("8w6d3q89dy1uea1")
    }
    
    var body: some Scene {
        WindowGroup {
            LyricVaultView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
