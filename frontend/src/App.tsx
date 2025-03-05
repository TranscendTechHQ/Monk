import { Component, onMount } from 'solid-js';
import { Router, Route, Navigate } from '@solidjs/router';
import NewsFeed from './components/NewsFeed';
import ThreadMessages from './components/ThreadMessages';
import { OpenAPI } from './api/core/OpenAPI';
import ProtectedRoute from './components/ProtectedRoute';
import { initSuperTokens } from "./lib/supertokens";
import Login from "./pages/Login";
import { userService } from './services/userService';
import Session from "supertokens-web-js/recipe/session";
import ThirdPartyCallback from './components/auth/ThirdPartyCallback';

// Initialize SuperTokens immediately when this module loads
console.log('[App] Initializing SuperTokens at module scope...');
try {
  initSuperTokens();
  console.log('[App] SuperTokens initialized successfully at module scope');
} catch (err) {
  console.error('[App] SuperTokens initialization failed at module scope:', err);
}

const apiDomain = import.meta.env.VITE_API_DOMAIN;
const websiteDomain = import.meta.env.VITE_WEBSITE_DOMAIN;
const apiBase = apiDomain + import.meta.env.VITE_API_BASE;

OpenAPI.BASE = String(apiBase);
OpenAPI.WITH_CREDENTIALS = true;

const App: Component = () => {
  onMount(async () => {
    console.log('[App] Initializing application...');
    try {
      // The userService.initialize() method now checks for session internally
      // so we don't need to check here, but we'll handle any errors gracefully
      await userService.initialize();
      console.log('[App] Initialization complete');
    } catch (err) {
      console.error('[App] Initialization failed:', err);
      // We don't need to redirect here as ProtectedRoute will handle that
    }
  });

  return (
    <Router>
      <Route path="/login" component={Login} />
      <Route path="/login/callback/:provider" component={ThirdPartyCallback} />
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