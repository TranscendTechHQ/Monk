


import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://localhost:3000/login');
  
  await page.getByRole('button', { name: 'Go to NewsFeed' }).click();
  // Assert that we are redirected to the newsfeed
  await expect(page).toHaveURL('http://localhost:3000/newsfeed', { timeout: 10000 });

});