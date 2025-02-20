import { test as setup, expect } from '@playwright/test';
import path from 'path';
import dotenv from 'dotenv';

dotenv.config();

const username = process.env.TEST_USERNAME;
const password = process.env.TEST_PASSWORD;

const authFile = path.join(__dirname, '../playwright/.auth/user.json');

setup('authenticate', async ({ page }) => {
  // Perform authentication steps. Replace these actions with your own.
  

    await page.goto('http://localhost:3000/login');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.getByRole('button', { name: 'Continue with Google' }).click();
    await page.getByRole('textbox', { name: 'Email or phone' }).fill(username!);
    await page.getByRole('button', { name: 'Next' }).click();
    await page.getByRole('textbox', { name: 'Enter your password' }).fill(password!);
    await page.getByRole('button', { name: 'Next' }).click();
    // Wait for the navigation to accounts.google.com
    await expect(page).toHaveURL(/https:\/\/accounts\.google\.com\/signin\/oauth/, { timeout: 10000 });
    await page.getByRole('button', { name: 'Continue' }).click();
    await page.getByRole('button', { name: 'Go to NewsFeed' }).click();

  
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  //await expect(page.getByRole('button', { name: 'View profile and more' })).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile });
});
