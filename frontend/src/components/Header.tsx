import { Component, Show, JSX } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import { useUser } from '../context/UserContext';

interface HeaderProps {
  onSearch?: () => void;
  onNewThread?: () => void;
  showActions?: boolean;
  children?: JSX.Element;
}

const Header: Component<HeaderProps> = (props) => {
  const navigate = useNavigate();
  const userContext = useUser();
  
  return (
    <header class="bg-slate-900 border-b border-slate-700 py-2 px-4">
      <div class="container mx-auto flex justify-between items-center">
        <div class="flex items-center">
          <div class="flex items-center" onClick={() => navigate('/newsfeed')} style="cursor: pointer">
            {/* Monk Logo */}
            <img 
              src="/svg/logo.svg" 
              alt="Monk Logo" 
              class="w-8 h-8 mr-2"
            />
            <h1 class="text-blue-500 font-bold text-xl" style="font-family: 'Montserrat', sans-serif; letter-spacing: 1px; text-shadow: 0 0 10px rgba(59, 130, 246, 0.5)">
              MONK
            </h1>
          </div>
          
          {/* Navigation Links */}
          <Show when={userContext?.user()}>
            <nav class="ml-6 flex space-x-4">
              <a 
                href="/newsfeed" 
                class="text-slate-300 hover:text-white transition-colors text-sm"
              >
                News Feed
              </a>
              <a 
                href="/admin" 
                class="text-slate-300 hover:text-white transition-colors text-sm"
              >
                Admin
              </a>
            </nav>
          </Show>
          
          {/* Custom content */}
          <Show when={props.children}>
            <div class="ml-6">
              {props.children}
            </div>
          </Show>
        </div>
        
        {/* Action Buttons */}
        <Show when={props.showActions}>
          <div class="flex space-x-2">
            <button
              onClick={props.onSearch}
              class="bg-slate-800 hover:bg-slate-700 text-white px-3 py-1 rounded text-sm transition-colors border border-slate-700"
            >
              Search
            </button>
            <button
              onClick={props.onNewThread}
              class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm transition-colors"
            >
              New Thread
            </button>
          </div>
        </Show>
      </div>
    </header>
  );
};

export default Header; 