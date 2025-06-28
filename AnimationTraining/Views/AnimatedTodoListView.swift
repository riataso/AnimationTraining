import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct AnimatedTodoList: View {
    @State private var todos: [TodoItem] = [
        TodoItem(title: "SwiftUIの勉強"),
        TodoItem(title: "登壇資料の準備"),
        TodoItem(title: "Todoアプリの実装"),
        TodoItem(title: "買い物に行く"),
        TodoItem(title: "本を読む")
    ]

    @State private var visibleItems: Set<UUID> = []
    @State private var newTodoText = ""

    var body: some View {
        VStack(spacing: 16) {
            // 新しいタスク追加
            HStack {
                TextField("新しいタスクを入力", text: $newTodoText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("追加") {
                    addTodo()
                }
                .disabled(newTodoText.isEmpty)
            }
            .padding(.horizontal)

            // Todoリスト
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(todos.enumerated()), id: \.element.id) { index, todo in
                        TodoRowView(todo: binding(for: todo))
                            // visibleItems: 表示状態を管理するSet<UUID>
                            // 画面表示時は空 → onAppearで順次追加してアニメーション発火
                            .offset(x: visibleItems.contains(todo.id) ? 0 : -300)
                            .animation(
                                .spring(response: 0.6)
                                .delay(Double(index) * 0.1),
                                value: visibleItems
                            )
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            for todo in todos {
                visibleItems.insert(todo.id)
            }
        }
    }

    private func binding(for todo: TodoItem) -> Binding<TodoItem> {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            fatalError("Todo not found")
        }
        return $todos[index]
    }

    private func addTodo() {
        let newTodo = TodoItem(title: newTodoText)
        todos.append(newTodo)
        newTodoText = ""

        // 新しいアイテムをアニメーションで表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            visibleItems.insert(newTodo.id)
        }
    }
}

struct TodoRowView: View {
    @Binding var todo: TodoItem

    var body: some View {
        HStack(spacing: 16) {
            // 完了チェックボックス
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    todo.isCompleted.toggle()
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }

            // タスク内容
            Text(todo.title)
                .font(.body)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.blue.opacity(0.1))
        )
    }
}

#Preview {
    AnimatedTodoList()
}
