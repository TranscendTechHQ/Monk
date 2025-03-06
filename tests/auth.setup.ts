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

// Validate that credentials are provided
if (!testEmail || !testPassword) {
  console.error('ERROR: TEST_GOOGLE_USERNAME and TEST_GOOGLE_PASSWORD environment variables must be set');
  process.exit(1);
}

setup('authenticate', async () => {
  // Launch browser with stealth and ignore SSL errors
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    ignoreHTTPSErrors: true,  // Bypass SSL certificate errors
  });
  const page = await context.newPage();

  // Navigate to login page
  await page.goto(websiteDomain + '/login');
  
  // Check if we're already redirected to newsfeed (already logged in)
  const currentUrl = page.url();
  if (currentUrl.includes('/newsfeed')) {
    console.log('Already logged in, saving auth state');
    await page.context().storageState({ path: authFile });
    await browser.close();
    return;
  }
  
  // Check if we're already logged in (session exists)
  const goToNewsFeedButton = page.getByText('Go to NewsFeed');
  if (await goToNewsFeedButton.isVisible()) {
    console.log('Already logged in, clicking Go to NewsFeed button');
    await goToNewsFeedButton.click();
    await page.waitForURL(/\/newsfeed/, { timeout: 10000 });
    await page.context().storageState({ path: authFile });
    await browser.close();
    return;
  }
  
  // Check if we need to sign up first
  let needsSignUp = false;
  
  // Try to sign in
  // Use more specific selectors based on the actual form structure
  await page.locator('input[type="email"]').fill(testEmail);
  await page.locator('input[type="password"]').fill(testPassword);
  await page.getByText('Sign In', { exact: true }).click();
  
  // Wait a moment to see if we get an error
  await page.waitForTimeout(2000);
  
  // Check for error message indicating invalid credentials
  const errorVisible = await page.getByText(/Invalid email or password|Something went wrong/).isVisible();
  
  if (errorVisible) {
    console.log('Login failed, attempting to sign up');
    needsSignUp = true;
  }
  
  // If sign up is needed
  if (needsSignUp) {
    // Switch to sign up mode
    await page.getByText('Create Account', { exact: true }).click();
    
    // Fill sign up form with more specific selectors
    await page.locator('input[type="email"]').fill(testEmail);
    await page.locator('input[type="password"]').fill(testPassword);
    await page.locator('input[type="text"]').fill('Test User');
    
    // Submit sign up form
    await page.getByRole('button', { name: 'Sign Up' }).click();
    
    // Wait for navigation to complete
    await page.waitForURL(/\/newsfeed/, { timeout: 10000 });
  } else {
    // Wait for navigation to complete after successful login
    await page.waitForURL(/\/newsfeed/, { timeout: 10000 });
  }
  
  // Verify we're on the newsfeed page
  await expect(page).toHaveURL(/\/newsfeed/);
  
  // Save authentication state
  await page.context().storageState({ path: authFile });
  
  await browser.close();
});