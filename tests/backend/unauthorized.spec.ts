import { test, expect } from '@playwright/test';



// Read the backend API URL from the API_DOMAIN environment variable
const backendApiUrl = String(process.env.API_DOMAIN);

// Configure tests to ignore HTTPS errors
test.use({ ignoreHTTPSErrors: true });

// Debug test to check cookies
/*
test('debug storage state', async ({ context }) => {
  const cookies = await context.cookies();
  console.log('Cookies:', cookies); // Should be empty
});
*/
// use new context for this test
test.use({ storageState: undefined });

test.describe('Unauthorized access', () => {
  // List of protected endpoints to test unauthorized access.
  // These endpoints are expected to return HTTP 401 if no valid session is provided.
  // Note that the backend API is mounted at /api in the backend container.
  // This is set in the docker-compose.yml file.

  console.log('running backend unauthorized access tests:', backendApiUrl);

  const endpoints = [

    { method: 'get', path: '/threads/upload-url?filename=test.txt', testName: 'upload-url' },
    { method: 'get', path: '/threads/download-url?filename=test.txt', testName: 'download-url' },
    // The create message endpoint, note that query parameters are used here for simplicity.
    { method: 'post', path: '/threads/message?thread_id=test_thread&text=Hello', body: {}, testName: 'message' },
    { method: 'get', path: '/threads/threads', testName: 'threads' },
    { method: 'get', path: '/threads/users', testName: 'users' },
    { method: 'get', path: '/threads/searchThreads?query=testing', testName: 'searchThreads' }
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
      console.log(`${endpoint.testName} response: expected 401, got ${response!.status()}`);
      expect(response!.status()).toBe(401);
    });
  }
}); 