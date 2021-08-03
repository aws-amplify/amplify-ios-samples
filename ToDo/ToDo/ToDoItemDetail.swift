import SwiftUI

/// Display the detail of a todo item.
public struct ToDoItemDetail: View {
    @EnvironmentObject var environment: ToDoEnvironment

    @State var id: String? = nil
    @State var priority: ToDoPriority = .medium
    @State var text: String = ""
    
    @State var priorityBefore: ToDoPriority = .medium
    @State var textBefore: String = ""
    @State var isCancel: Bool = false

    let logger: Logger

    public init(logger: Logger = DefaultLogger()) {
        self.logger = logger
    }

    ///Control Save button
    var saveDisabled: Bool {
        text.isEmpty
    }
    
    /// Todo item detail view. Control add or update a Todo item.
    public var body: some View {
        NavigationView {
            VStack {
                ///Use ToDoItemPriorityPicker to display/edit priority.
                ToDoItemPriorityPicker(priority: $priority)
                ///Display/edit task.
                TextField("Write your new ToDo here!", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 50.0)
                Spacer()
                    .navigationTitle("ToDo Item")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        ///Values are binding. When cancel, selectedToDoItem should be nil. If something changes, call alert.
                        if priority != priorityBefore || text != textBefore {
                            isCancel = true
                        }
                        else {
                            environment.selectedToDoItem = nil
                            environment.showingDetail = false
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ///Use ToDoEnvironment to update/add to the list.
                    Button(action: {
                        let item = ToDoItem(id: id,
                                            priority: priority,
                                            text: text)
                        logger.info("Saving Item: \(item)")
                        environment.saveToDoItem(toDoItem: item)
                    }, label: {
                        Text("Done")
                    })
                    .disabled(saveDisabled)
                }
            }
        }
        .alert(isPresented: $isCancel, content: {
            return Alert(title: Text("Discard Changes"), message: Text("Are you sure you want to discard the changes made?"), primaryButton: .default(Text("Yes"), action: {
                environment.selectedToDoItem = nil
                environment.showingDetail = false
            }), secondaryButton: .destructive(Text("No")))
        })
        ///Get selected Todo item information which is the current Todo item.
        .onAppear {
            if let item = environment.selectedToDoItem {
                logger.info("Loading Item: \(item)")
                id = item.id
                priority = item.priority
                text = item.text
                priorityBefore = priority
                textBefore = text
            }
        }
    }
}

struct ToDoItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemDetail().environmentObject(ToDoEnvironment())
    }
}
