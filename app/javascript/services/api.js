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
  let projects = await response.json();
  return projects.map(transformProjectToFrontend);
};

export const fetchProject = async (id) => {
  const response = await fetch(`/api/projects/${id}`);
  if (!response.ok) throw new Error('Failed to fetch project');
  return transformProjectToFrontend(await response.json());
};

export const createProject = async (projectData) => {
  const transformedData = await transformProjectToApi(projectData);
  const response = await fetch('/api/projects', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify({ project: transformedData })
  });
  if (!response.ok) throw new Error('Failed to create project');
  return transformProjectToFrontend(await response.json());
};

export const updateProject = async (id, projectData) => {
  const response = await fetch(`/api/projects/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify({ project: await transformProjectToApi(projectData) })
  });
  if (!response.ok) throw new Error('Failed to update project');
  return transformProjectToFrontend(await response.json());
};

export const deleteProject = async (id) => {
  const response = await fetch(`/api/projects/${id}`, {
    method: 'DELETE',
    credentials: 'same-origin'
  });
  if (!response.ok) throw new Error('Failed to delete project');
};

export const archiveProject = async (id, isArchived) => {
  const response = await fetch(`/api/projects/${id}/archive`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'same-origin',
    body: JSON.stringify({ is_archived: isArchived })
  });
  if (!response.ok) throw new Error('Failed to archive project');
  return transformProjectToFrontend(await response.json());
};

function encodeFileToBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result.split(',')[1]); // Get base64 string
    reader.onerror = error => reject(error);
    reader.readAsDataURL(file);
  });
}

function transformProjectToFrontend(project) {
  return {
    ...project,
    comments: project.description,
    socialLinks: {
      telegram: project.telegram_url,
      instagram: project.instagram_url,

      vk: project.vkontakte_url,
      youtube: project.youtube_url,
      tiktok: project.tiktok_url,
      yandex: project.yandex_zen_url
    },
    photoMaterials: (project.project_photos || []),
    mapLinks: (project.project_map_links || []),
    designLinks: (project.project_design_links || []),
    references: (project.project_reference_links || []),
    files: (project.project_files || []).map(file => {
      const blob = new Blob([atob(file.data)]);
      return {id: file.id, name: file.filename, data: new File([blob], file.filename)};
    })
  };
}

export const transformProjectToApi = async (project) => {
  console.log('transformProjectToApi', project.files)
  const encodedFiles = await Promise.all((project.files || []).map(async file => ({
    id: file.id,
    filename: file.name,
    data: await encodeFileToBase64(file.data),
    _destroy: file._destroy
  })));

  return {
    ...project,
    name: project.name,
    description: project.comments || '',
    telegram_url: project.socialLinks.telegram || '',
    instagram_url: project.socialLinks.instagram || '',
    vkontakte_url: project.socialLinks.vk || '',
    youtube_url: project.socialLinks.youtube || '',
    tiktok_url: project.socialLinks.tiktok || '',
    yandex_zen_url: project.socialLinks.yandex || '',
    project_photos_attributes: (project.photoMaterials || []),
    project_map_links_attributes: (project.mapLinks || []),
    project_design_links_attributes: (project.designLinks || []),
    project_reference_links_attributes: (project.references || []),
    project_files_attributes: encodedFiles
  };
};
