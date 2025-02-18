import SwiftUI
import Foundation

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted = false
}

struct ContentView: View {
    
    @State private var tasks: [Task] = [
        Task(title: "Купить продукты"),
        Task(title: "Прогуляться"),
    ]
    
    @State private var newTaskTitle: String = ""
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchQuery)
                    List {
                        ForEach(filteredTasks) { task in
                            HStack {
                                Text(task.title)
                                    .strikethrough(task.isCompleted, color: .black)
                                Spacer()
                                Button(action: {
                                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                        tasks[index].isCompleted.toggle()
                                    }
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    
                    HStack {
                        TextField("Новая задача", text: $newTaskTitle)
                            .bold()
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                        
                        Button(action: addTask) {
                            Text("Добавить")
                                .font(.system(size: 20))
                                .bold()
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }.padding(.horizontal, 15)
                    .navigationTitle("Задачи")
                }
            }
    }
    
    var filteredTasks: [Task] {
        if searchQuery.isEmpty {
                return tasks
        } else {
            return tasks.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        tasks.append(Task(title: newTaskTitle))
        newTaskTitle = ""
    }

    func deleteTask(at: IndexSet) {
        tasks.remove(atOffsets: at)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Найти", text: $text)
            .bold()
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .cornerRadius(10)
            .padding(.horizontal)
            .font(.system(size: 20))
    }
}

#Preview {
    ContentView()
}
