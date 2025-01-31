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
import { initUserCache } from './utils/userUtils';
import { userService } from './services/userService';

// Keep API configuration
OpenAPI.BASE = 'http://localhost:8001';

const App: Component = () => {
  onMount(async () => {
    console.log('[App] Component mounted - starting initialization');
    try {
      await userService.initialize();
      console.log('[App] User service initialized');
    } catch (err) {
      console.error('[App] Initialization failed:', err);
    }
  });

  return (
    <Router>
      <Route path="/auth/*" component={Auth} />
      <Route path="/login/*" component={Login} />
      <Route path="/" component={() => <Navigate href="/newsfeed" />} />
      <Route path="/newsfeed" component={NewsFeed} />
      <Route path="/thread/:id" component={ThreadMessages} />
    </Router>
  );
};

export default App;
 