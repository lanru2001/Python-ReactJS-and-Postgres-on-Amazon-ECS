// In production this is baked in at Docker build time via --build-arg
// REACT_APP_API_URL (see frontend/Dockerfile and the CI workflow).
// Falls back to a relative /api path for local dev behind a proxy, or same-origin.
const API_BASE = process.env.REACT_APP_API_URL || "";

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });

  if (!response.ok) {
    let detail = response.statusText;
    try {
      const body = await response.json();
      detail = body.detail || detail;
    } catch {
      // response had no JSON body - stick with statusText
    }
    throw new Error(detail);
  }

  if (response.status === 204) {
    return null;
  }
  return response.json();
}

export function listTodos() {
  return request("/api/todos");
}

export function createTodo(title) {
  return request("/api/todos", {
    method: "POST",
    body: JSON.stringify({ title }),
  });
}

export function updateTodo(id, changes) {
  return request(`/api/todos/${id}`, {
    method: "PUT",
    body: JSON.stringify(changes),
  });
}

export function deleteTodo(id) {
  return request(`/api/todos/${id}`, { method: "DELETE" });
}
