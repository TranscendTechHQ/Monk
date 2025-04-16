import { Component, createSignal, onMount } from 'solid-js';
import { useNavigate, useParams } from '@solidjs/router';
import * as ThirdParty from 'supertokens-web-js/recipe/thirdparty';
import { useUser } from '../../context/UserContext';
import Header from '../Header';
import Footer from '../Footer';

const ThirdPartyCallback: Component = () => {
  const [error, setError] = createSignal<string | null>(null);
  const [loading, setLoading] = createSignal(true);
  const params = useParams();
  const navigate = useNavigate();
  const userContext = useUser();

  onMount(async () => {
    try {
      // Handle the callback from the third-party provider
      const response = await ThirdParty.signInAndUp();
      
      if (response.status === "OK") {
        // Refresh user data
        if (userContext) {
          await userContext.refreshUser();
        }
        
        // Navigate to newsfeed
        navigate('/newsfeed');
      } else {
        setError("Something went wrong during sign-in. Please try again.");
        setTimeout(() => {
          navigate('/login');
        }, 3000);
      }
    } catch (err: any) {
      console.error("Third-party sign-in error:", err);
      setError(err.message || "Failed to complete sign-in");
      setTimeout(() => {
        navigate('/login');
      }, 3000);
    } finally {
      setLoading(false);
    }
  });

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      <div class="flex-1 flex items-center justify-center">
        <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96 border border-slate-700 text-center">
          {loading() ? (
            <div class="space-y-4">
              <h2 class="text-white text-xl font-medium">Processing Sign In</h2>
              <div class="flex justify-center">
                <svg class="animate-spin h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              </div>
              <p class="text-slate-300">
                Please wait while we complete your sign-in...
              </p>
            </div>
          ) : error() ? (
            <div class="space-y-4">
              <h2 class="text-white text-xl font-medium">Sign In Failed</h2>
              <p class="text-red-400">{error()}</p>
              <p class="text-slate-300">
                Redirecting you back to the login page...
              </p>
            </div>
          ) : (
            <div class="space-y-4">
              <h2 class="text-white text-xl font-medium">Sign In Successful</h2>
              <p class="text-slate-300">
                Redirecting you to the app...
              </p>
            </div>
          )}
        </div>
      </div>
      
      <Footer />
    </div>
  );
};

export default ThirdPartyCallback; 