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

// Keep API configuration
OpenAPI.BASE = 'http://localhost:8001';

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
      <Route path="/auth/*" component={Auth} />
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
 