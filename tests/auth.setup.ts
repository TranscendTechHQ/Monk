import path from 'path';
import dotenv from 'dotenv';
import { test as setup, expect } from '@playwright/test';
import { chromium } from 'playwright-extra';
import StealthPlugin from 'puppeteer-extra-plugin-stealth';

chromium.use(StealthPlugin());
dotenv.config();
const authFile = path.join(__dirname, '../playwright/.auth/user.json');

// Use environment variables for credentials
const testEmail = process.env.TEST_GOOGLE_USERNAME || '';
const testPassword = process.env.TEST_GOOGLE_PASSWORD || '';
const websiteDomain = String(process.env.WEBSITE_DOMAIN);

// Increase timeouts for CI environments
const navigationTimeout = 30000; // 30 seconds
const actionTimeout = 10000;     // 10 seconds

// Validate that credentials are provided
if (!testEmail || !testPassword) {
  console.error('ERROR: TEST_GOOGLE_USERNAME and TEST_GOOGLE_PASSWORD environment variables must be set');
  process.exit(1);
}

setup('authenticate', async () => {
  console.log(`Starting authentication process with email: ${testEmail.substring(0, 3)}***`);
  console.log(`Website domain: ${websiteDomain}`);
  
  // Launch browser with stealth and ignore SSL errors
  const browser = await chromium.launch({ 
    headless: true,
    args: [
      '--disable-dev-shm-usage', // Overcome limited resource problems in CI
      '--no-sandbox',            // Required for running in CI
      '--disable-setuid-sandbox',
      '--disable-gpu',           // Reduce resource usage
      '--disable-web-security',  // Bypass CORS issues
    ]
  });
  
  const context = await browser.newContext({
    ignoreHTTPSErrors: true,  // Bypass SSL certificate errors
    viewport: { width: 1280, height: 720 },
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
  });
  
  const page = await context.newPage();

  try {
    console.log(`Navigating to login page: ${websiteDomain}/login`);
    // Navigate to login page with longer timeout
    await page.goto(websiteDomain + '/login', { timeout: navigationTimeout });
    
    
    // Check if we're already redirected to newsfeed (already logged in)
    const currentUrl = page.url();
    console.log(`Current URL after navigation: ${currentUrl}`);
    
    if (currentUrl.includes('/newsfeed')) {
      console.log('Already logged in, saving auth state');
      await page.context().storageState({ path: authFile });
      await browser.close();
      return;
    }
    
    // Check if we're already logged in (session exists)
    const goToNewsFeedButton = page.getByText('Go to NewsFeed');
    const isButtonVisible = await goToNewsFeedButton.isVisible();
    console.log(`"Go to NewsFeed" button visible: ${isButtonVisible}`);
    
    if (isButtonVisible) {
      console.log('Already logged in, clicking Go to NewsFeed button');
      await goToNewsFeedButton.click();
      await page.waitForURL(/\/newsfeed/, { timeout: navigationTimeout });
      await page.context().storageState({ path: authFile });
      await browser.close();
      return;
    }
    
    // Check if login form is visible
    const emailInput = page.locator('input[type="email"]');
    const isEmailInputVisible = await emailInput.isVisible();
    console.log(`Email input visible: ${isEmailInputVisible}`);
    
    if (!isEmailInputVisible) {
      console.error('Login form not found. ');

      throw new Error('Login form not found');
    }
    
    // Try to sign in
    console.log('Filling login form...');
    await emailInput.fill(testEmail);
    await page.locator('input[type="password"]').fill(testPassword);
    

    
    // Click sign in and wait for either navigation or error
    console.log('Clicking Sign In button...');
    await page.getByText('Sign In', { exact: true }).click();
    
    // Wait a moment to see if we get an error
    await page.waitForTimeout(5000);
    

    
    // Check for error message indicating invalid credentials
    const errorVisible = await page.getByText(/Invalid email or password|Something went wrong/).isVisible();
    console.log(`Error message visible: ${errorVisible}`);
    
    // Check if we need to sign up
    let needsSignUp = false;
    if (errorVisible) {
      console.log('Login failed, attempting to sign up');
      needsSignUp = true;
    }
    
    // If sign up is needed
    if (needsSignUp) {
      console.log('Switching to sign up mode...');
      // Switch to sign up mode
      await page.getByText('Create Account', { exact: true }).click();
      
      // Fill sign up form with more specific selectors
      console.log('Filling sign up form...');
      await page.locator('input[type="email"]').fill(testEmail);
      await page.locator('input[type="password"]').fill(testPassword);
      await page.locator('input[type="text"]').fill('Test User');
      
    
      
      // Submit sign up form
      console.log('Submitting sign up form...');
      await page.getByRole('button', { name: 'Sign Up' }).click();
      
      // Wait for navigation to complete with increased timeout
      console.log('Waiting for navigation to newsfeed after sign up...');
      try {
        await page.waitForURL(/\/newsfeed/, { timeout: navigationTimeout });
      } catch (error) {
        console.error('Navigation timeout after sign up. Current URL:', page.url());
        
        
        // Try to manually navigate to newsfeed
        console.log('Attempting to manually navigate to newsfeed...');
        await page.goto(websiteDomain + '/newsfeed', { timeout: navigationTimeout });
      }
    } else {
      // Wait for navigation to complete after successful login
      console.log('Waiting for navigation to newsfeed after login...');
      try {
        await page.waitForURL(/\/newsfeed/, { timeout: navigationTimeout });
      } catch (error) {
        console.error('Navigation timeout after login. Current URL:', page.url());
        
        
        // Try to manually navigate to newsfeed
        console.log('Attempting to manually navigate to newsfeed...');
        await page.goto(websiteDomain + '/newsfeed', { timeout: navigationTimeout });
      }
    }
    
  
    
    // Check if we're on the newsfeed page
    const finalUrl = page.url();
    console.log(`Final URL: ${finalUrl}`);
    
    if (!finalUrl.includes('/newsfeed')) {
      console.error('Not on newsfeed page after authentication process');
      throw new Error('Authentication failed: Not redirected to newsfeed');
    }
    
    console.log('Successfully authenticated and reached newsfeed');
    
    // Save authentication state
    await page.context().storageState({ path: authFile });
    console.log('Authentication state saved to:', authFile);
  } catch (error) {
    console.error('Authentication error:', error);
    
    throw error;
  } finally {
    await browser.close();
    console.log('Browser closed');
  }
});