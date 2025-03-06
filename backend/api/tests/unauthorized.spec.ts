import { test, expect } from '@playwright/test';
// Read the backend API URL from the API_DOMAIN environment variable, defaulting to  if not set
const backendApiUrl = String(process.env.API_DOMAIN);

test.describe('Unauthorized access', () => {
  // List of protected endpoints to test unauthorized access.
  // These endpoints are expected to return HTTP 401 if no valid session is provided.
  // Note that the backend API is mounted at /api in the backend container.
  // This is set in the docker-compose.yml file.
  // now ignore https errors
  test.use({ ignoreHTTPSErrors: true });
  const endpoints = [
    { method: 'get', path: '/api/threads/upload-url?filename=test.txt' },
    { method: 'get', path: '/api/threads/download-url?filename=test.txt' },
    // The create message endpoint, note that query parameters are used here for simplicity.
    { method: 'post', path: '/api/threads/message?thread_id=test_thread&text=Hello', body: {} },
    { method: 'get', path: '/api/threads/threads' },
    { method: 'get', path: '/api/threads/users' },
    { method: 'get', path: '/api/threads/searchThreads?query=testing' }
  ];

  for (const endpoint of endpoints) {
    test(`${endpoint.method.toUpperCase()} ${endpoint.path} should return unauthorized`, async ({ request }) => {
      let response;
      if (endpoint.method === 'get') {
        response = await request.get(`${backendApiUrl}${endpoint.path}`);
      } else if (endpoint.method === 'post') {
        response = await request.post(`${backendApiUrl}${endpoint.path}`, { data: endpoint.body });
      }
      // Ensure the response status is 401 Unauthorized
      expect(response).toBeDefined();
      expect(response!.status()).toBe(401);
    });
  }
}); 