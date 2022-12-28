//
//  Screen2.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import SwiftyDropbox
import SwiftUI


//func myButtonInControllerPressed() {
//    // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
//    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
//    DropboxClientsManager.authorizeFromControllerV2(
//        UIApplication.shared,
//        controller: self,
//        loadingStatusDelegate: nil,
//        openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
//        scopeRequest: scopeRequest
//    )                                            })
//}

struct ScreenTwo: View {
    var viewController = ViewController()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Screen 2")
                    .bold()
                    .foregroundColor(.white)
                Spacer().frame(height: 50)
                Button {
                } label: {
                    Text("Button")
                }
                Spacer().frame(height: 50)
                Button(action: {
                    viewController.myButtonInControllerPressed()
                }, label: {
                    Text("Dropbox Login")  // Authorization
                })
            }
//            .onAppear {
//                let listFolders = dropboxClient.files.listFolder(path: "")
//                listFolders.response{ response, error in
//                        guard let result = response else{
//                            return
//                        }
//                for entry in result.entries{
//                    print(entry)
//                }
//            }
        }
        
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(.pink)
        .clipped()
    }
        
}

struct ScreenTwo_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwo()
    }
}


class ViewController: UIViewController {
    
    func myButtonInControllerPressed() {
        // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
}

