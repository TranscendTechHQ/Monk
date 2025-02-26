import path from 'path';
import dotenv from 'dotenv';

import { test as setup, expect } from '@playwright/test';
import { chromium } from 'playwright-extra';
import StealthPlugin from 'puppeteer-extra-plugin-stealth';

chromium.use(StealthPlugin());
dotenv.config();
const authFile = path.join(__dirname, '../playwright/.auth/user.json');

const username = process.env.TEST_GOOGLE_USERNAME;
const password = process.env.TEST_GOOGLE_PASSWORD;
const websiteDomain = String(process.env.WEBSITE_DOMAIN);
setup('authenticate', async ({ page }) => {
  const browser = await chromium.launch({ headless: true });
  const stealthPage = await browser.newPage();

  //console.log('websiteDomain', websiteDomain);
  //console.log('username', username);
  //console.log('password', password);
  await stealthPage.goto(websiteDomain + '/login');
  await stealthPage.getByRole('button', { name: 'Sign in' }).click();
  await stealthPage.getByRole('button', { name: 'Continue with Google' }).click();

  const html = await stealthPage.locator('body').innerHTML();

  await stealthPage.getByRole('textbox', { name: 'Email or phone' }).fill(username!);
  await stealthPage.getByRole('button', { name: 'Next' }).click();
  await stealthPage.getByRole('textbox', { name: 'Enter your password' }).fill(password!);
  await stealthPage.getByRole('button', { name: 'Next' }).click();
  // Wait for the navigation to accounts.google.com
  await expect(stealthPage).toHaveURL(/https:\/\/accounts\.google\.com\/signin\/oauth/, { timeout: 10000 });
  await stealthPage.getByRole('button', { name: 'Continue' }).click();
  await stealthPage.getByRole('button', { name: 'Go to NewsFeed' }).click();

  
  await stealthPage.context().storageState({ path: authFile });

  await browser.close();
});
