import { test, expect } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

const websiteDomain = String(process.env.WEBSITE_DOMAIN);

// Configure tests to ignore HTTPS errors
test.use({ ignoreHTTPSErrors: true });
const navigationTimeout = 30000; // 30 seconds

test('postlogin test', async ({ page, context }) => {
  // Print cookies to check if auth is loaded
  const cookies = await context.cookies();
  //console.log(`Cookies loaded: ${cookies.length}`);
  
  await page.goto(websiteDomain + '/login');
  console.log('Current URL:', page.url());

  // Check if we're already logged in (session exists)
  const goToNewsFeedButton = page.getByText('Go to NewsFeed');
  const isButtonVisible = await goToNewsFeedButton.isVisible();
  console.log(`"Go to NewsFeed" button visible: ${isButtonVisible}`);

  if (isButtonVisible) {
    console.log('Auth credentials loaded successfully');
    await goToNewsFeedButton.click();
    await page.waitForURL(/\/newsfeed/, { timeout: navigationTimeout });
    await expect(page).toHaveURL(websiteDomain + '/newsfeed', { timeout: 10000 });
  }
  else {
    console.log('Not logged in, failed to load the auth credentials. TEST FAILED');
    throw new Error('Not logged in, failed to load the auth credentials. TEST FAILED');
  }
});