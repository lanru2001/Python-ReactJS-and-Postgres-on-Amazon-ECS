import React, { useEffect, useState } from "react";
import "./App.css";
import { listTodos, createTodo, updateTodo, deleteTodo } from "./api";

function App() {
  const [todos, setTodos] = useState([]);
  const [title, setTitle] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    refresh();
  }, []);

  async function refresh() {
    try {
      setLoading(true);
      setTodos(await listTodos());
      setError(null);
    } catch (err) {
      setError("Couldn't load todos. Is the backend running?");
    } finally {
      setLoading(false);
    }
  }

  async function handleSubmit(event) {
    event.preventDefault();
    const trimmed = title.trim();
    if (!trimmed || submitting) return;

    setSubmitting(true);
    try {
      const created = await createTodo(trimmed);
      setTodos((prev) => [created, ...prev]);
      setTitle("");
      setError(null);
    } catch (err) {
      setError("Couldn't add that todo. Try again.");
    } finally {
      setSubmitting(false);
    }
  }

  async function toggleComplete(todo) {
    const previous = todos;
    setTodos((prev) =>
      prev.map((t) =>
        t.id === todo.id ? { ...t, completed: !t.completed } : t
      )
    );
    try {
      await updateTodo(todo.id, { completed: !todo.completed });
    } catch (err) {
      setTodos(previous); // roll back on failure
      setError("Couldn't update that todo.");
    }
  }

  async function removeTodo(id) {
    const previous = todos;
    setTodos((prev) => prev.filter((t) => t.id !== id));
    try {
      await deleteTodo(id);
    } catch (err) {
      setTodos(previous);
      setError("Couldn't delete that todo.");
    }
  }

  const remaining = todos.filter((t) => !t.completed).length;

  return (
    <div className="app">
      <div className="card">
        <h1>Todo</h1>

        <form className="add-form" onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="What needs doing?"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            aria-label="New todo title"
          />
          <button type="submit" disabled={submitting || !title.trim()}>
            Add
          </button>
        </form>

        {error && <p className="error">{error}</p>}

        {loading ? (
          <p className="empty">Loading…</p>
        ) : todos.length === 0 ? (
          <p className="empty">Nothing here yet — add your first todo above.</p>
        ) : (
          <>
            <ul className="todo-list">
              {todos.map((todo) => (
                <li key={todo.id} className={todo.completed ? "done" : ""}>
                  <label>
                    <input
                      type="checkbox"
                      checked={todo.completed}
                      onChange={() => toggleComplete(todo)}
                    />
                    <span>{todo.title}</span>
                  </label>
                  <button
                    className="delete-btn"
                    onClick={() => removeTodo(todo.id)}
                    aria-label={`Delete ${todo.title}`}
                  >
                    ×
                  </button>
                </li>
              ))}
            </ul>
            <p className="footer">
              {remaining} of {todos.length} remaining
            </p>
          </>
        )}
      </div>
    </div>
  );
}

export default App;
