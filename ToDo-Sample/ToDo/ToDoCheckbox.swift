import SwiftUI

struct ToDoCheckbox: View {
    @Binding var item: ToDoItem
    
    var body: some View {
        switch item.priority {
        case .low:
            Image(systemName: "square")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 24, height: 24)
        case .medium:
            Image(systemName: "square")
                .resizable()
                .foregroundColor(Color.orange)
                .frame(width: 24, height: 24)
        case .high:
            Image(systemName: "square")
                .resizable()
                .foregroundColor(Color.red)
                .frame(width: 24, height: 24)
        }
    }
}

struct ToDoCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        let item = ToDoItem(text: "Eat breakfast")
        ToDoCheckbox(item: .constant(item))
    }
}
