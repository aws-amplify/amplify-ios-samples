//
//  Main file including Amplify configuration
//  AmplifyConfigTemplate
//
//  Created by AWS Amplify.
//
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import SwiftUI

@main
struct ToDo: App {
    let logger: Logger
    
    public init() {
        self.logger = DefaultLogger()
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ToDoMainView().environmentObject(createEnvironment())
        }
    }

    private func createEnvironment() -> ToDoEnvironment {
        let env = ToDoEnvironment()
        env.initTodo()
        return env
    }

    ///Configure Amplify
    func configureAmplify() {
        let models = AmplifyModels()
        //    let apiPlugin = AWSAPIPlugin(modelRegistration: models)
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
        do {
            //        try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
            logger.info("Initialized Amplify");
        } catch {
            assert(false, "Could not initialize Amplify: \(error)")
        }
    }

}
