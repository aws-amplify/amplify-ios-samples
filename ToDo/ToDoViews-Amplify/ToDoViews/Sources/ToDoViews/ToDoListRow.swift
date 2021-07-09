//
//  SwiftUIView.swift
//  
//
//  Created by Stehling, Brennan on 6/14/21.
//

import SwiftUI

/// Display a row in the Todo list.
public struct ToDoListRow: View {
    ///Binding one TodoItem in the list.
    @Binding var toDoItem: ToDoItem

    public var body: some View {
        HStack{
            switch toDoItem.priority {
            case .low:
                VStack{
                    Rectangle().frame(width: 8.0).foregroundColor(.blue)
                }
                Spacer().frame(width: 5)
                HStack {
                    Image(systemName: "l.circle").resizable()
                        .foregroundColor(.blue)
                        .frame(width: 24.0, height: 24.0)
                    Text(toDoItem.text).strikethrough((toDoItem.completedAt != nil)).foregroundColor((toDoItem.completedAt != nil) ? Color(.systemGray2) : .black)
                }
            case .medium:
                VStack{
                    Rectangle().frame(width: 8.0).foregroundColor(.orange)
                }
                Spacer().frame(width: 5)
                HStack {
                    Image(systemName: "m.circle").resizable()
                        .foregroundColor(.orange)
                        .frame(width: 24.0, height: 24.0)
                    Text(toDoItem.text).strikethrough((toDoItem.completedAt != nil)).foregroundColor((toDoItem.completedAt != nil) ? Color(.systemGray2) : .black)
                }
            case .high:
                VStack{
                    Rectangle().frame(width: 8.0).foregroundColor(.red)
                }
                Spacer().frame(width: 5)
                HStack {
                    Image(systemName: "h.circle").resizable()
                        .foregroundColor(.red)
                        .frame(width: 24.0, height: 24.0)
                    Text(toDoItem.text).strikethrough((toDoItem.completedAt != nil)).foregroundColor((toDoItem.completedAt != nil) ? Color(.systemGray2) : .black)
                }
            }
        }
        .animation(.spring(response: 2))
    }
}

struct ToDoListRow_Previews: PreviewProvider {
    static var previews: some View {
        let item = ToDoItem(text: "Eat breakfast")
        ToDoListRow(toDoItem: .constant(item))
    }
}
