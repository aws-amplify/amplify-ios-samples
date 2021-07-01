//
//  SwiftUIView.swift
//  
//
//  Created by Stehling, Brennan on 6/14/21.
//

import SwiftUI

/// Display Todo list. Control TodoListRow and ToDoItemDetail. Delete TodoItem.
public struct ToDoList: View {
    @EnvironmentObject var environment: ToDoEnvironment

    @State var showingDetail: Bool = false
    
    private var showTime = 300.0
    
    public var body: some View {
        ///Display Todo list. Loop can be used in List to display whole elements.
        List {
            ForEach(environment.toDoItems.indices, id: \.self) { index in
                ///Click one Todo item, showingDetail to be true, call .sheet to show TodoItemDetail. selectedToDoItem store current Todo item.
                if !environment.toDoItems[index].completed! {
                    HStack {
                        Button(action: {
                            print("Text in List: \(environment.toDoItems[index])")
                            environment.selectedToDoItem = environment.toDoItems[index]
                            environment.showingDetail = true
                        }, label: {
                            ///Transfer toDoItem to ToDoListRow to display. toDoItem should add $ to keep binding to TodoListRow.
                            ToDoListRow(toDoItem: $environment.toDoItems[index])
                    })
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: {
                            environment.toDoItems[index].completed!.toggle()
                            environment.createTodo(toDoItem: environment.toDoItems[index])
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
                    if environment.toDoItems[index].completed! {
                        HStack{
                            ToDoListRow(toDoItem: $environment.toDoItems[index])
                            Spacer()
                            Button(action: {
                                environment.toDoItems[index].completed!.toggle()
                                environment.createTodo(toDoItem: environment.toDoItems[index])
                            }, label: {
                                ToDoCheckboxFill(item: $environment.toDoItems[index])
//                                    Image(systemName: "checkmark.square.fill")
//                                        .resizable()
//                                        .foregroundColor(Color.orange)
//                                        .frame(width: 24, height: 24)
                            })
                            .frame(width: 60, height: 50)
                        }
                        .animation(.spring())
                        .onAppear {
                            let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: self.showTime))
                            let completedItem = environment.toDoItems[index]
                            RunLoop.main.schedule(after: _delay) {
                                environment.remove(toDoItem: completedItem)
                                            }
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
        env.save(toDoItem: ToDoItem(text: "Eat breakfast"))
        return ToDoList().environmentObject(env)
    }
}
