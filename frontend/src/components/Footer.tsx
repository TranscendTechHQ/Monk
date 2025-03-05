import { Component, Show } from 'solid-js';
import Session from 'supertokens-web-js/recipe/session';
import { useUser } from '../context/UserContext';
import { useNavigate } from '@solidjs/router';

const Footer: Component = () => {
  const userContext = useUser();
  const navigate = useNavigate();

  const signOut = async () => {
    await Session.signOut();
    userContext?.setUser(null);
    navigate('/auth');
  };

  return (
    <footer class="bg-slate-900 border-t border-slate-700 py-2 px-4">
      <div class="container mx-auto flex justify-between items-center">
        <div class="text-xs text-slate-500">
          © {new Date().getFullYear()} Monk
        </div>
        
        <Show when={userContext?.user()}>
          <div class="flex items-center">
            <div class="w-6 h-6 rounded-full mr-2 bg-blue-600 flex items-center justify-center">
              <span class="text-white text-xs font-bold">
                {userContext?.user()?.name?.[0] || userContext?.user()?.email?.[0] || '?'}
              </span>
            </div>
            <span class="text-sm text-slate-300 mr-3">
              {userContext?.user()?.name || userContext?.user()?.email}
            </span>
            <button 
              onClick={signOut}
              class="text-xs text-red-400 hover:text-red-300 transition-colors"
            >
              Sign Out
            </button>
          </div>
        </Show>
      </div>
    </footer>
  );
};

export default Footer; 