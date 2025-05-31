// API service for authentication and user management

export const login = async (email, password) => {
  try {
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'same-origin',
      body: JSON.stringify({ email, password }),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || 'Failed to login');
    }

    return data;
  } catch (error) {
    throw error;
  }
};

export const register = async (userData) => {
  try {
    const response = await fetch('/api/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'same-origin',
      body: JSON.stringify({ user: userData }),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || 'Failed to register');
    }

    return data;
  } catch (error) {
    throw error;
  }
};

// Project API
export const fetchProjects = async () => {
  const response = await fetch('/api/projects');
  if (!response.ok) throw new Error('Failed to fetch projects');
  return response.json();
};

export const fetchProject = async (id) => {
  const response = await fetch(`/api/projects/${id}`);
  if (!response.ok) throw new Error('Failed to fetch project');
  return response.json();
};

export const createProject = async (projectData) => {
  const response = await fetch('/api/projects', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify({ project: projectData })
  });
  if (!response.ok) throw new Error('Failed to create project');
  return response.json();
};

export const updateProject = async (id, projectData) => {
  const response = await fetch(`/api/projects/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify({ project: projectData })
  });
  if (!response.ok) throw new Error('Failed to update project');
  return response.json();
};

export const deleteProject = async (id) => {
  const response = await fetch(`/api/projects/${id}`, {
    method: 'DELETE',
    credentials: 'same-origin'
  });
  if (!response.ok) throw new Error('Failed to delete project');
};
