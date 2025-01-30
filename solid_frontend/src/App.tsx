/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import { Router, Route } from '@solidjs/router';
import UserInfo from './components/UserInfo';
import NewsFeed from './components/NewsFeed';
import ThreadMessages from './components/ThreadMessages';
import { OpenAPI } from './api/core/OpenAPI';

// Add this before the App component
OpenAPI.BASE = 'http://localhost:8001';

const App: Component = () => {
  return (
    <div class="min-h-screen bg-slate-900">
      <main class="py-12">
        <div class="container mx-auto h-[600px]">
          <NewsFeed />
        </div>
      </main>
      <UserInfo />
    </div>
  );
};

export const Root = () => (
  <Router>
    <Route path="/" component={App} />
    <Route path="/thread/:id" component={ThreadMessages} />
  </Router>
);

export default App;
 