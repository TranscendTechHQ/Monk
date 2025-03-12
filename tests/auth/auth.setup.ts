import path from 'path';
import dotenv from 'dotenv';
import { test as setup } from '@playwright/test';
import { chromium } from 'playwright';


dotenv.config();
const authFile = path.join(__dirname, '../.auth/user.json');

const testEmail = process.env.TEST_GOOGLE_USERNAME || '';
const testPassword = process.env.TEST_GOOGLE_PASSWORD || '';
const websiteDomain = process.env.WEBSITE_DOMAIN ;


const navigationTimeout = 60000; // Bump to 60s for debugging

if (!testEmail || !testPassword) {
  console.error('ERROR: TEST_GOOGLE_USERNAME and TEST_GOOGLE_PASSWORD must be set');
  process.exit(1);
}




setup('authenticate', async () => {
  console.log(`Starting authentication with email: ${testEmail.substring(0, 3)}***`);
  //console.log(`Website domain: ${websiteDomain}`);

  const browser = await chromium.launch({
    headless: true,
    args: [
      '--disable-dev-shm-usage',
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-gpu',
      '--ignore-certificate-errors', // Extra SSL bypass
    ],
  });
  const context = await browser.newContext({
    ignoreHTTPSErrors: true,
    viewport: { width: 1280, height: 720 },
    extraHTTPHeaders: { 'Accept': '*/*' }, // Avoid content negotiation issues
  });
  const page = await context.newPage();


  await page.route('https://localhost/**', async (route) => {
    const req = route.request();
    const url = new URL(req.url());
    const method = req.method();
    const postData = req.postData();
  
    // Log request details
    console.log(`Intercepting ${method} request to ${url.toString()}`);
    if (postData) {
      console.log(`Request data: ${postData.substring(0, 100)}...`);
    }
  
    // Rewrite the URL to point to nginx
    url.host = 'nginx';
    console.log(`Redirecting request to ${url.toString()}`);

    // Fetch the response from the backend
    let response;
    try {
      response = await route.fetch({
        url: url.toString(),
        method: req.method(),
        headers: req.headers(),
        postData: req.postData(),
      });
  
      // Log response details
     // console.log(`Response for ${url.toString()}:`);
      //console.log(`Status: ${response.status()}`);
      //console.log('Headers:', JSON.stringify(response.headers(), null, 2));
  
      // Attempt to log the response body (truncated)
      try {
        const responseBody = await response.text();
        //console.log(`Response body (truncated): ${responseBody.substring(0, 200)}...`);
      } catch (error) {
        console.error('Failed to read response body:', error);
      }
    } catch (error) {
      console.error(`Error fetching response for ${url.toString()}:`, error);
      throw error;
    }
  
    // Continue with the rewritten URL and original request
    route.continue({
      url: url.toString(),
      method: req.method(),
      headers: req.headers(),
      postData: req.postData(),
    });
  
    // Log that the request was forwarded
    console.log(`Request forwarded to ${url.toString()}`);
  });
  
  


  try {
    console.log(`Navigating to: ${websiteDomain}/login`);
    await page.goto(`${websiteDomain}/login`, { timeout: navigationTimeout });
    console.log(`Current URL: ${page.url()}`);

    if (page.url().includes('/newsfeed')) {
      console.log('Already logged in, saving state');
      await page.context().storageState({ path: authFile });
      return;
    }

    const emailInput = page.locator('input[type="email"]');
    const isEmailInputVisible = await emailInput.isVisible({ timeout: 5000 });
    console.log(`Email input visible: ${isEmailInputVisible}`);

    if (!isEmailInputVisible) {
      console.error('Login form not found');
      throw new Error('Login form not found');
    }

    console.log('Filling login form...');
    await emailInput.fill(testEmail);
    await page.locator('input[type="password"]').fill(testPassword);

    // print the list of all buttons on the page and form text input field in the page to console
    // in the log, also print button text and text befote input field value
    const buttons = await page.locator('button').all();
    // make sure all the values are resolved and not promises
    console.log('Buttons:', await Promise.all(
      buttons.map(async (button) => ({
        text: await button.textContent(),
        value: await button.getAttribute('value'),
      }))
    ));
    const textInputs = await page.locator('input').all();
    console.log(' Inputs:', await Promise.all(
      textInputs.map(async (input) => ({ 
        value: await input.getAttribute('value') 
      }))
    ));
/*
    page.on('request', (request) => {
      console.log(`Request: ${request.method()} ${request.url()}`);
      console.log('Headers:', JSON.stringify(request.headers(), null, 2));
    });
    
    page.on('response', async (response) => {
      console.log(`Response: ${response.status()} ${response.url()}`);
      const body = await response.text();
      console.log(`Response Body: ${body}`);
    });

    page.on('console', (msg) => console.log(`[Browser Console] ${msg.type()}: ${msg.text()}`));
    page.on('pageerror', (err) => console.error(`[Browser Error] ${err.message}`));
*/
    
    // press the Sign In button. Find the button by text
    console.log('Submitting form...');
    // press the Sign In button. Find the button by text
    await page.locator('button', { hasText: 'Sign In' }).click();

    // after the form is submitted, print the URL of the page
    console.log('Current URL after submission:', page.url());

    // Wait for navigation or timeout
    try {
      await page.waitForURL(`${websiteDomain}/newsfeed`, { timeout: navigationTimeout });
      console.log(`URL after login: ${page.url()}`);
    } catch (e) {
      console.log(`Navigation failed, current URL: ${page.url()}`);
      const errorMessage = await page.locator('text=/Invalid|Something went wrong/i').textContent();
      console.log(`Error on page: ${errorMessage || 'None visible'}`);
      throw e;
    }

    const cookies = await context.cookies();
    //console.log('Cookies after login:', JSON.stringify(cookies, null, 2));
    if (cookies.length === 0) {
      console.error('No cookies set after login');
      throw new Error('No cookies set');
    }

    console.log('Saving auth state');
    await page.context().storageState({ path: authFile });
    console.log('State saved to:', authFile);
    await page.waitForLoadState('networkidle', { timeout: 30000 });
    console.log('Network idle, continuing...');

  } catch (error) {
    console.error('Authentication error:', error);
    //await page.screenshot({ path: 'error.png' });
    console.log('Page content:', await page.content());
    throw error;
  } finally {
    await browser.close();
    console.log('Browser closed');
  }
});