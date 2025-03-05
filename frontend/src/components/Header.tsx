import { Component, Show } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import Session from 'supertokens-web-js/recipe/session';
import { useUser } from '../context/UserContext';

const Header: Component = () => {
  const navigate = useNavigate();
  const userContext = useUser();
  const user = () => userContext?.user?.() || null;

  const handleSignOut = async () => {
    try {
      // Sign out from SuperTokens
      await Session.signOut();
      
      // Clear the user context
      if (userContext) {
        userContext.setUser(null);
      }
      
      // Force a complete page reload to clear all state
      window.location.href = '/login';
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  return (
    <header class="bg-slate-800 text-white p-4 shadow-md">
      <div class="container mx-auto flex justify-between items-center">
        <div class="flex items-center">
          <h1 class="text-xl font-bold">Monk</h1>
          <nav class="ml-8">
            <ul class="flex space-x-4">
              <li>
                <a 
                  href="/newsfeed" 
                  class="hover:text-slate-300 transition-colors"
                >
                  NewsFeed
                </a>
              </li>
            </ul>
          </nav>
        </div>
        
        <div class="flex items-center">
          <Show when={user()}>
            <div class="mr-4 text-sm">
              <span class="font-medium">{user()?.name}</span>
              <span class="text-slate-400 ml-2">({user()?.email})</span>
            </div>
            <button 
              onClick={handleSignOut}
              class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm transition-colors"
            >
              Sign Out
            </button>
          </Show>
        </div>
      </div>
    </header>
  );
};

export default Header; 