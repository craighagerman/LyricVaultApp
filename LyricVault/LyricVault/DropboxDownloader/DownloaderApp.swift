//
//  DownloaderApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-26.
//

import Foundation

import SwiftyDropbox
import SwiftUI


//@main
struct DownloaderApp: App {

    let persistenceController = PersistenceController.shared

    init() {
        DropboxClientsManager.setupWithAppKey("8w6d3q89dy1uea1")
    }

    var body: some Scene {
        WindowGroup {
//            DBDirListView()
            ImportSongsView()
        }
    }
}
