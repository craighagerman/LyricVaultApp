//
//  LyricVaultApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import SwiftyDropbox
import SwiftUI


//@main
struct DropboxTestApp: App {
    
    let persistenceController = PersistenceController.shared

    init() {
        DropboxClientsManager.setupWithAppKey("8w6d3q89dy1uea1")
    }

    var body: some Scene {
        WindowGroup {
            DBFilesView()
//            ContentViewDB()
//            SongListView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


//func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//     let oauthCompletion: DropboxOAuthCompletion = {
//      if let authResult = $0 {
//          switch authResult {
//          case .success:
//              print("Success! User is logged into DropboxClientsManager.")
//          case .cancel:
//              print("Authorization flow was manually canceled by user!")
//          case .error(_, let description):
//              print("Error: \(String(describing: description))")
//          }
//      }
//    }
//
//    for context in URLContexts {
//        // stop iterating after the first handle-able url
//        if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
//    }
//}
