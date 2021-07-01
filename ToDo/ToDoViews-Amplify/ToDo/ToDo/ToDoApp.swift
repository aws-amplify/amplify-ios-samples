//
//  ToDoApp.swift
//  ToDo
//
//  Created by Stehling, Brennan on 6/14/21.
//
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import SwiftUI
import ToDoViews

@main
struct ToDoApp: App {
    public init() {
           configureAmplify()
       }
    
    var body: some Scene {
        WindowGroup {
            ///When use @EnvironmentObject, must use this.
            ToDoMainView().environmentObject(createEnvironment())
        }
    }

    private func createEnvironment() -> ToDoEnvironment {
        let env = ToDoEnvironment()
//        env.save(toDoItem: ToDoItem(priority: .high, text: "Eat breakfast"))
//        env.save(toDoItem: ToDoItem(priority: .medium, text: "Eat lunch"))
//        env.save(toDoItem: ToDoItem(priority: .low, text: "Eat dinner"))
        env.initTodo()
        return env
    }
}

func configureAmplify() {
    let models = AmplifyModels()
    let apiPlugin = AWSAPIPlugin(modelRegistration: models)
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
    do {
        try Amplify.add(plugin: apiPlugin)
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        assert(false, "Could not initialize Amplify: \(error)")
    }
}
