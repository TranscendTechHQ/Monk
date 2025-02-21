import { test, expect } from '@playwright/test';
// Read the backend API URL from the API_DOMAIN environment variable, defaulting to  if not set
const backendApiUrl = String(process.env.API_DOMAIN);

test.describe('Unauthorized access', () => {
  // List of protected endpoints to test unauthorized access.
  // These endpoints are expected to return HTTP 401 if no valid session is provided.
  const endpoints = [
    { method: 'get', path: '/upload-url?filename=test.txt' },
    { method: 'get', path: '/download-url?filename=test.txt' },
    // The create message endpoint, note that query parameters are used here for simplicity.
    { method: 'post', path: '/message?thread_id=test_thread&text=Hello', body: {} },
    { method: 'get', path: '/threads' },
    { method: 'get', path: '/users' },
    { method: 'get', path: '/searchThreads?query=testing' }
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