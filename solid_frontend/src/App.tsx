/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import { Router, Route, Navigate } from '@solidjs/router';
import NewsFeed from './components/NewsFeed';
import ThreadMessages from './components/ThreadMessages';
import { OpenAPI } from './api/core/OpenAPI';
import Login, { Auth } from './Auth';
import { initUserCache } from './utils/userUtils';

// Keep API configuration
OpenAPI.BASE = 'http://localhost:8001';

// Initialize user cache on app load
initUserCache();

const App: Component = () => {
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
 