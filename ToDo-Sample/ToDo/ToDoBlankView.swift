import SwiftUI

struct ToDoBlankView: View {
    var body: some View {
        VStack {
            Text("No ToDo Items")
                .font(.title)
                .foregroundColor(Color.gray)
            Text("Use Add in the upper right corner to create Todo Items!")
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ToDoBlankView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoBlankView()
    }
}
