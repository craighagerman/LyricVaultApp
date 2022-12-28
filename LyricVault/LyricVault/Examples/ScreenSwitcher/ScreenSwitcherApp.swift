//
//  LyricVaultApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import SwiftyDropbox
import SwiftUI



//@main
struct ScreenSwitcherApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var router = TabRouter()

    init() {
        DropboxClientsManager.setupWithAppKey("8w6d3q89dy1uea1")
    }

    var body: some Scene {
        WindowGroup {
            //            ContentView()
            TabView(selection: $router.screen) {
                ScreenOne()
                    .tag(Screen.one)
                    .environmentObject(router)
                    .tabItem {
                        Label("Screen 1", systemImage: "calendar")
                    }
                ScreenTwo()
                    .tag(Screen.two)
                    .tabItem {
                        Label("Screen 2", systemImage: "house")
                    }
                LibraryView()
                    .tag(Screen.library)
                    .tabItem {
                        Label("Lyric Library", systemImage: "building.columns")
                    }

            }
        }
    }
}



func sceneSS(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
     let oauthCompletion: DropboxOAuthCompletion = {
      if let authResult = $0 {
          switch authResult {
          case .success:
              print("Success! User is logged into DropboxClientsManager.")
          case .cancel:
              print("Authorization flow was manually canceled by user!")
          case .error(_, let description):
              print("Error: \(String(describing: description))")
          }
      }
    }

    for context in URLContexts {
        // stop iterating after the first handle-able url
        if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
    }
}


enum ScreenSS {
    case one
    case two
    case library
}

final class TabRouterSS: ObservableObject {
    @Published var screen: Screen = .one

    func change(to screen: Screen) {
        self.screen = screen
    }
}


class AppDelegateSS: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        return true
    }
}


