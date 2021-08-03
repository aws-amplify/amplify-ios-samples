import SwiftUI

public struct ToDoItemPriorityPicker: View {
    @Binding var priority: ToDoPriority

    public var body: some View {
        VStack {
            Text("Priority of this ToDo Item?")
                .font(.subheadline)
                .padding(.top, 5.0)
                .foregroundColor(/*@START_MENU_TOKEN@*/Color(hue: 1.0, saturation: 0.044, brightness: 0.815)/*@END_MENU_TOKEN@*/)
            Picker("Priority", selection: $priority) {
                Text(String(describing: ToDoPriority.low))
                    .tag(ToDoPriority.low)
                Text(String(describing: ToDoPriority.medium))
                    .tag(ToDoPriority.medium)
                Text(String(describing: ToDoPriority.high))
                    .tag(ToDoPriority.high)
            }
            .frame(height: 20.0)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }
}

struct ToDoItemPriorityPicker_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemPriorityPicker(priority: .constant(.medium))
    }
}
