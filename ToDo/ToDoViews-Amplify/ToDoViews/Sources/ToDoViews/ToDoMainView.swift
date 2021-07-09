//
//  SwiftUIView.swift
//  
//
//  Created by Stehling, Brennan on 6/14/21.
//
import Amplify
import Combine
import SwiftUI

/// Homepage. Control Add button and TodoList.
public struct ToDoMainView: View {
    @EnvironmentObject var environment: ToDoEnvironment

    public init() {
    }

    public var body: some View {
        NavigationView {
            if environment.toDoItems.isEmpty {
                ToDoBlankView()
                    .navigationTitle("ToDo")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                print("Add new ToDo item")
                                environment.selectedToDoItem = nil
                                environment.showingDetail = true
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .sheet(isPresented: $environment.showingDetail) {
                        ToDoItemDetail()
                    }
            }
            else {
                ToDoList()
                    .navigationTitle("ToDo")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                print("Add new ToDo item")
                                environment.selectedToDoItem = nil
                                environment.showingDetail = true
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            self.performOnAppear()
        }
    }
    
    @State var todoSubscription: AnyCancellable?
    
    func subscribeTodos() {
       self.todoSubscription
           = Amplify.DataStore.publisher(for: ToDoItem.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")

                   do {
                     let todo = try mutationEvent.decodeModel(as: ToDoItem.self)

                     switch mutationEvent.mutationType {
                     case "create":
                       print("Created: \(todo)")
                     case "update":
                       print("Updated: \(todo)")
                     case "delete":
                       print("Deleted: \(todo)")
                     default:
                       break
                     }

                   } catch {
                     print("Model could not be decoded: \(error)")
                   }
               })
    }
    
    func performOnAppear() {
        subscribeTodos()
    }
}

struct ToDoMainView_Previews: PreviewProvider {
    static var previews: some View {
        let env = ToDoEnvironment()
        env.save(toDoItem: ToDoItem(text: "Eat breakfast"))
        return ToDoMainView().environmentObject(env)
    }
}
