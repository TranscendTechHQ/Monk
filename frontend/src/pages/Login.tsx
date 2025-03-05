import { Component, createSignal, onMount, Show } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import * as Session from "supertokens-web-js/recipe/session";
import { useUser } from '../context/UserContext';
import Header from '../components/Header';
import Footer from '../components/Footer';

const Login: Component = () => {
  const [data, setData] = createSignal<{
    userId: string | null;
    session: boolean;
  }>({
    userId: null,
    session: false,
  });

  const navigate = useNavigate();
  const userContext = useUser();
  const user = () => userContext?.user?.() || null;

  onMount(async () => {
    const { userId, session } = await getUserInfo();
    setData({ userId, session });
    
    // If session exists, make sure user data is refreshed
    if (session && userContext) {
      await userContext.refreshUser();
    }
  });

  const handleSignOut = async () => {
    try {
      // Sign out from SuperTokens
      await Session.signOut();
      
      // Clear the user context
      if (userContext) {
        userContext.setUser(null);
      }
      
      // Update session state
      setData({ userId: null, session: false });
      
      // Reload the page to reset everything
      window.location.reload();
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      <div class="flex-1 flex items-center justify-center">
        <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96 border border-slate-700">
          <h1 class="text-white text-3xl font-bold text-center mb-4">Hello!</h1>

          <Show when={data().session}>
            <div class="text-center space-y-4">
              <Show 
                when={user()} 
                fallback={
                  <div class="text-slate-300 flex items-center justify-center gap-2">
                    <svg 
                      class="animate-spin h-5 w-5 text-white" 
                      xmlns="http://www.w3.org/2000/svg" 
                      fill="none" 
                      viewBox="0 0 24 24"
                    >
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Loading profile...
                  </div>
                }
              >
                <h2 class="text-white text-xl font-medium">
                  Welcome back, {user()!.name}
                </h2>
                <p class="text-slate-300">
                  {user()!.email}
                </p>
              </Show>
              <button
                onClick={() => navigate('/newsfeed')}
                class="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200"
              >
                Go to NewsFeed
              </button>
              <button 
                onClick={handleSignOut} 
                class="w-full border border-slate-600 text-white bg-slate-700 hover:bg-slate-600 transition duration-200 py-2 px-4 rounded"
              >
                Sign Out
              </button>
            </div>
          </Show>

          <Show when={!data().session}>
            <p class="text-slate-300 text-center mt-4">
              Please sign in to continue
            </p>
            <button 
              onClick={redirectToSignIn} 
              class="w-full mt-4 bg-blue-600 text-white hover:bg-blue-700 transition duration-200 py-2 px-4 rounded"
            >
              Sign in
            </button>
          </Show>
        </div>
      </div>
      
      <Footer />
    </div>
  );
};

async function getUserInfo() {
  const session = await Session.doesSessionExist();
  if (session) {
    const userId = await Session.getUserId();
    return { userId, session };
  }
  return { userId: null, session: false };
}

function redirectToSignIn() {
  window.location.href = import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH;
}

export default Login; 