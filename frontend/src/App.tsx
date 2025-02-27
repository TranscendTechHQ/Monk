/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, onMount } from 'solid-js';
import { Router, Route, Navigate } from '@solidjs/router';
import NewsFeed from './components/NewsFeed';
import ThreadMessages from './components/ThreadMessages';
import { OpenAPI } from './api/core/OpenAPI';
import Login, { Auth } from './Auth';
import ProtectedRoute from './components/ProtectedRoute';

import { userService } from './services/userService';


const apiDomain = import.meta.env.VITE_API_DOMAIN;
const websiteDomain = import.meta.env.VITE_WEBSITE_DOMAIN;
const apiBase = apiDomain + import.meta.env.VITE_API_BASE;
const superTokensWebsiteBasePath = import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH + "/*";
// Keep API configuration
OpenAPI.BASE = String(apiBase);
OpenAPI.WITH_CREDENTIALS = true;  // Ensures cookies (e.g., SuperTokens session) are sent

const App: Component = () => {
  onMount(async () => {
    console.log('[App] Initializing application...');
    try {
      await userService.initialize();
      console.log('[App] Initialization complete');
    } catch (err) {
      console.error('[App] Initialization failed:', err);
    }
  });

  return (
    <Router>
      <Route path={superTokensWebsiteBasePath} component={Auth} />
      <Route path="/login/*" component={Login} />
      <Route path="/" component={() => <Navigate href="/login" />} />
      <Route path="/newsfeed" component={() => (
        <ProtectedRoute>
          <NewsFeed />
        </ProtectedRoute>
      )} />
      <Route path="/thread/:id" component={() => (
        <ProtectedRoute>
          <ThreadMessages />
        </ProtectedRoute>
      )} />
    
    </Router>
  );
};

export default App;
 