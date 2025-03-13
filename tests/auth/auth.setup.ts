import path from 'path';
import dotenv from 'dotenv';
import { test as setup } from '@playwright/test';
import { chromium } from 'playwright';


dotenv.config();
const authFile = path.join(__dirname, '../.auth/user.json');

const testEmail = process.env.TEST_GOOGLE_USERNAME || '';
const testPassword = process.env.TEST_GOOGLE_PASSWORD || '';
const websiteDomain = process.env.WEBSITE_DOMAIN ;


// Increase timeouts for CI environments
const navigationTimeout = 120000; // 2 minutes
const globalTimeout = 180000;  // 3 minutes

if (!testEmail || !testPassword) {
  console.error('ERROR: TEST_GOOGLE_USERNAME and TEST_GOOGLE_PASSWORD must be set');
  process.exit(1);
}


// Increase the test timeout
setup.setTimeout(globalTimeout);

setup('authenticate', async () => {
  console.log(`Starting authentication with email: ${testEmail.substring(0, 3)}***`);
  console.log(`Website domain: ${websiteDomain}`);
  
  let browser;
  let context;
  let page;

  try {
    browser = await chromium.launch({
      headless: true,
      args: [
        '--disable-dev-shm-usage',
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-gpu',
        '--ignore-certificate-errors',
        '--disable-web-security',
        '--disable-features=IsolateOrigins,site-per-process',
      ],
      timeout: navigationTimeout,
    });
    
    context = await browser.newContext({
      ignoreHTTPSErrors: true,
      viewport: { width: 1280, height: 720 },
      extraHTTPHeaders: { 'Accept': '*/*' },
      // Increase timeouts for context operations
      navigationTimeout: navigationTimeout,
      timeout: navigationTimeout,
    });
    
    page = await context.newPage();
    
    // Enable verbose logging
    page.on('console', msg => console.log(`[Browser Console] ${msg.type()}: ${msg.text()}`));
    page.on('pageerror', err => console.error(`[Browser Error] ${err.message}`));
    page.on('requestfailed', request => console.error(`[Request Failed] ${request.url()} ${request.failure()?.errorText || 'unknown error'}`));

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
      try {
        const response = await route.fetch({
          url: url.toString(),
          method: req.method(),
          headers: req.headers(),
          postData: req.postData(),
          timeout: navigationTimeout
        });
    
        // Log response status
        console.log(`Response status for ${url.toString()}: ${response.status()}`);
      } catch (error) {
        console.error(`Error fetching response for ${url.toString()}:`, error);
        // Continue anyway to avoid blocking the test
      }
    
      // Continue with the rewritten URL and original request
      try {
        await route.continue({
          url: url.toString(),
          method: req.method(),
          headers: req.headers(),
          postData: req.postData(),
        });
        console.log(`Request forwarded to ${url.toString()}`);
      } catch (error) {
        console.error(`Error forwarding request to ${url.toString()}:`, error);
        // Try to fulfill with an empty response to avoid hanging
        try {
          await route.fulfill({ status: 200, body: '{}' });
        } catch (e) {
          console.error('Failed to fulfill route as fallback:', e);
        }
      }
    });
    
    console.log(`Navigating to: ${websiteDomain}/login`);
    await page.goto(`${websiteDomain}/login`, { timeout: navigationTimeout, waitUntil: 'networkidle' });
    console.log(`Current URL after navigation: ${page.url()}`);

    // Take a screenshot for debugging
    await page.screenshot({ path: 'login-page.png' });
    console.log('Login page screenshot saved');

    if (page.url().includes('/newsfeed')) {
      console.log('Already logged in, saving state');
      await page.context().storageState({ path: authFile });
      return;
    }

    // Wait longer for the email input to appear
    const emailInput = page.locator('input[type="email"]');
    const isEmailInputVisible = await emailInput.isVisible({ timeout: 30000 });
    console.log(`Email input visible: ${isEmailInputVisible}`);

    if (!isEmailInputVisible) {
      console.error('Login form not found');
      console.log('Page content:', await page.content());
      await page.screenshot({ path: 'login-form-not-found.png' });
      throw new Error('Login form not found');
    }

    console.log('Filling login form...');
    await emailInput.fill(testEmail);
    await page.locator('input[type="password"]').fill(testPassword);

    // Print form elements for debugging
    const buttons = await page.locator('button').all();
    console.log('Buttons:', await Promise.all(
      buttons.map(async (button) => ({
        text: await button.textContent(),
        value: await button.getAttribute('value'),
      }))
    ));
    
    const textInputs = await page.locator('input').all();
    console.log('Inputs:', await Promise.all(
      textInputs.map(async (input) => ({ 
        value: await input.getAttribute('value'),
        type: await input.getAttribute('type'),
        name: await input.getAttribute('name')
      }))
    ));
    
    // Submit the form
    console.log('Submitting form...');
    const signInButton = page.locator('button', { hasText: 'Sign In' });
    
    // Make sure the button is visible and enabled
    await signInButton.waitFor({ state: 'visible', timeout: 30000 });
    const isEnabled = await signInButton.isEnabled();
    console.log(`Sign In button enabled: ${isEnabled}`);
    
    if (!isEnabled) {
      console.error('Sign In button is disabled');
      await page.screenshot({ path: 'button-disabled.png' });
      throw new Error('Sign In button is disabled');
    }
    
    await signInButton.click({ timeout: 30000 });
    console.log('Form submitted');

    // After form submission, print the URL
    console.log('Current URL after submission:', page.url());
    await page.screenshot({ path: 'after-submission.png' });

    // Wait for navigation with increased timeout
    try {
      await page.waitForURL(`${websiteDomain}/newsfeed`, { timeout: navigationTimeout });
      console.log(`Successfully navigated to newsfeed. URL: ${page.url()}`);
    } catch (e) {
      console.log(`Navigation failed, current URL: ${page.url()}`);
      await page.screenshot({ path: 'navigation-failed.png' });
      
      // Try to get any error message from the page
      try {
        const errorMessage = await page.locator('text=/Invalid|Something went wrong|Error/i').textContent();
        console.log(`Error on page: ${errorMessage || 'None visible'}`);
      } catch (err) {
        console.error('Failed to check for error messages:', err);
      }
      
      throw e;
    }

    // Check cookies
    const cookies = await context.cookies();
    console.log(`Found ${cookies.length} cookies after login`);
    
    if (cookies.length === 0) {
      console.error('No cookies set after login');
      throw new Error('No cookies set');
    }

    // Save authentication state
    console.log('Saving auth state');
    await page.context().storageState({ path: authFile });
    console.log('State saved to:', authFile);
    
    // Wait for network to be idle
    await page.waitForLoadState('networkidle', { timeout: 60000 });
    console.log('Network idle, authentication complete');
    
    // Unroute all routes
    await page.unrouteAll({ behavior: 'ignoreErrors' });

  } catch (error) {
    console.error('Authentication error:', error);
    
    // Take a screenshot of the error state
    if (page) {
      try {
        await page.screenshot({ path: 'auth-error.png' });
        console.log('Error screenshot saved');
        console.log('Page content at error:', await page.content());
      } catch (e) {
        console.error('Failed to capture error state:', e);
      }
    }
    
    throw error;
  } finally {
    // Make sure we save any state we have before closing
    if (context) {
      try {
        await context.storageState({ path: authFile });
        console.log('Final state saved before closing');
      } catch (e) {
        console.error('Failed to save final state:', e);
      }
    }
    
    // Close browser
    if (browser) {
      try {
        await browser.close();
        console.log('Browser closed successfully');
      } catch (e) {
        console.error('Error closing browser:', e);
      }
    }
  }
});