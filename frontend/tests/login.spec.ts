


import { test, expect } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

const websiteDomain = String(process.env.WEBSITE_DOMAIN);

test('test', async ({ page }) => {
  await page.goto(websiteDomain + '/login');
  
  await page.getByRole('button', { name: 'Go to NewsFeed' }).click();
  // Assert that we are redirected to the newsfeed
  await expect(page).toHaveURL(websiteDomain + '/newsfeed', { timeout: 10000 });

});