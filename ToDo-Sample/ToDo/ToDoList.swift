import SwiftUI
import Amplify

/// Display Todo list. Control TodoListRow and ToDoItemDetail. Delete TodoItem.
public struct ToDoList: View {
    @EnvironmentObject var environment: ToDoEnvironment

    @State var showingDetail: Bool = false
    
    private var showTime = -3.0

    let logger: Logger

    public init(logger: Logger = DefaultLogger()) {
        self.logger = logger
    }
    
    public var body: some View {
        ///Display Todo list. Loop can be used in List to display whole elements.
        List {
            ForEach(environment.toDoItems.indices, id: \.self) { index in
                ///Click one Todo item, showingDetail to be true, call .sheet to show TodoItemDetail. selectedToDoItem store current Todo item.
                if (environment.toDoItems[index].completedAt == nil) {
                    HStack {
                        Button(action: {
                            logger.info("Text in List: \(environment.toDoItems[index])")
                            environment.selectedToDoItem = environment.toDoItems[index]
                            environment.showingDetail = true
                        }, label: {
                            ///Transfer toDoItem to ToDoListRow to display. toDoItem should add $ to keep binding to TodoListRow.
                            ToDoListRow(toDoItem: $environment.toDoItems[index])
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: {
                            environment.toDoItems[index].completedAt = Temporal.DateTime.now()
                            environment.saveToDoItem(toDoItem: environment.toDoItems[index])
                            environment.disappearCompletedItems(showTime: showTime)
                        }, label: {
                            ToDoCheckbox(item: $environment.toDoItems[index])
                        })
                        .frame(width: 60, height: 50)
                    }
                    .listRowBackground(Color.white)
                }
            }
            ///delete selected Todo item.
            .onDelete(perform: { indexSet in
                environment.remove(at: indexSet)
            })
            ///Dispay completed ToDo items
            Section(header: Text("Completed items")) {
                ForEach(environment.toDoItems.indices, id: \.self) { index in
                    if (environment.toDoItems[index].completedAt != nil) {
                        HStack{
                            ToDoListRow(toDoItem: $environment.toDoItems[index])
                            Spacer()
                            Button(action: {
                                environment.toDoItems[index].completedAt = nil
                                environment.saveToDoItem(toDoItem: environment.toDoItems[index])
                            }, label: {
                                ToDoCheckboxFill(item: $environment.toDoItems[index])
                            })
                            .frame(width: 60, height: 50)
                        }
                        .animation(.spring())
                        .onAppear() {
                            environment.disappearCompletedItems(showTime: showTime)
                        }
                    }
                }
            }
        }
        ///Show ToDoItemDetail view.
        .sheet(isPresented: $environment.showingDetail) {
            ToDoItemDetail()
        }
    }

}

struct ToDoList_Previews: PreviewProvider {
    static var previews: some View {
        let env = ToDoEnvironment()
        env.saveToDoItem(toDoItem: ToDoItem(text: "Eat breakfast"))
        return ToDoList().environmentObject(env)
    }
}