import Amplify
import Combine
import SwiftUI

/// Homepage. Control Add button and TodoList.
public struct ToDoMainView: View {
    @EnvironmentObject var environment: ToDoEnvironment

    let logger: Logger
    
    public init(logger: Logger = DefaultLogger()) {
        self.logger = logger
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
                                logger.info("Add new ToDo item")
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
                                logger.info("Add new ToDo item")
                                environment.selectedToDoItem = nil
                                environment.showingDetail = true
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            self.subscribeTodos()
        }
    }
    
    @State var todoSubscription: AnyCancellable?
    
    func subscribeTodos() {
        self.todoSubscription
            = Amplify.DataStore.publisher(for: ToDoItem.self)
            .sink(receiveCompletion: { completion in
                logger.info("Subscription has been completed: \(completion)")
            }, receiveValue: { mutationEvent in
                logger.info("Subscription got this value: \(mutationEvent)")

                do {
                    let todo = try mutationEvent.decodeModel(as: ToDoItem.self)

                    switch mutationEvent.mutationType {
                    case "create":
                        logger.info("Created: \(todo)")
                    case "update":
                        logger.info("Updated: \(todo)")
                    case "delete":
                        logger.info("Deleted: \(todo)")
                    default:
                        break
                    }

                } catch {
                    logger.error("Model could not be decoded: \(error)")
                }
            })
    }
}

struct ToDoMainView_Previews: PreviewProvider {
    static var previews: some View {
        let env = ToDoEnvironment()
        env.saveToDoItem(toDoItem: ToDoItem(text: "Eat breakfast"))
        return ToDoMainView().environmentObject(env)
    }
}
