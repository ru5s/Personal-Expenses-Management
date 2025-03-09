//
//  Flux_ZenithyApp.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      UITabBar.appearance().isTranslucent = true
      UITabBar.appearance().backgroundColor = UIColor.fzBlackBoard
      UITabBar.appearance().barTintColor = UIColor.fzBlackBoard
      UITabBar.appearance().unselectedItemTintColor = UIColor.fzGray
      
      return true
  }
}

@main
struct Flux_ZenithyApp: App {
    let persistenceController = CoreDataManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var model = Flux_ZenithyAppViewModel()

    var body: some Scene {
        WindowGroup {
            VStack(content: {
                if let event = model.event {
                    SplashView(event: event)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .preferredColorScheme(.dark)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.fzBlackBoard)
            .ignoresSafeArea()
            .onAppear(perform: {
                model.eventRequest { event in
                    model.event = event
                }
            })
        }
    }
}
