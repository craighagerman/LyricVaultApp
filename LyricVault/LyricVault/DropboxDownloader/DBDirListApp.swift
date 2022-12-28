//
//  DBDirListApp.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-22.
//

import SwiftyDropbox
import SwiftUI


//@main
struct DBDirListApp: App {

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
//                LibraryView()
//                    .tag(Screen.library)
//                    .tabItem {
//                        Label("Lyric Library", systemImage: "building.columns")
//                    }

            }
        }
    }
}


enum Screen {
    case one
    case two
    case library
}


final class TabRouter: ObservableObject {
    @Published var screen: Screen = .one

    func change(to screen: Screen) {
        self.screen = screen
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        return true
    }
}
