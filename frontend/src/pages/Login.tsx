import { Component, createSignal, onMount, Show } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import * as Session from "supertokens-web-js/recipe/session";
import * as EmailPassword from "supertokens-web-js/recipe/emailpassword";
import * as ThirdParty from "supertokens-web-js/recipe/thirdparty";
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

  const [email, setEmail] = createSignal('');
  const [password, setPassword] = createSignal('');
  const [name, setName] = createSignal('');
  const [isSignUp, setIsSignUp] = createSignal(false);
  const [error, setError] = createSignal('');
  const [loading, setLoading] = createSignal(false);
  const [googleLoading, setGoogleLoading] = createSignal(false);

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

  const handleSignIn = async (e: Event) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    try {
      let response = await EmailPassword.signIn({
        formFields: [
          { id: "email", value: email() },
          { id: "password", value: password() }
        ]
      });
      
      if (response.status === "OK") {
        // Refresh user data
        if (userContext) {
          await userContext.refreshUser();
        }
        
        // Update session state
        setData({ userId: response.user.id, session: true });
        
        // Navigate to newsfeed
        navigate('/newsfeed');
      } else {
        // This should not happen, but just in case
        setError("Something went wrong. Please try again.");
      }
    } catch (err: any) {
      console.error("Sign in error:", err);
      setError(err.message || "Invalid email or password");
    } finally {
      setLoading(false);
    }
  };

  const handleSignUp = async (e: Event) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    try {
      let response = await EmailPassword.signUp({
        formFields: [
          { id: "email", value: email() },
          { id: "password", value: password() },
          { id: "name", value: name() }
        ]
      });
      
      if (response.status === "OK") {
        // Auto sign-in after successful sign-up
        try {
          const signInResponse = await EmailPassword.signIn({
            formFields: [
              { id: "email", value: email() },
              { id: "password", value: password() }
            ]
          });
          
          if (signInResponse.status === "OK") {
            // Refresh user data
            if (userContext) {
              await userContext.refreshUser();
            }
            
            // Update session state
            setData({ userId: signInResponse.user.id, session: true });
            
            // Navigate to newsfeed
            navigate('/newsfeed');
          } else {
            // This should not happen, but just in case
            setError("Account created but couldn't sign in automatically. Please sign in manually.");
            setIsSignUp(false);
          }
        } catch (signInErr: any) {
          console.error("Auto sign-in error:", signInErr);
          setError("Account created successfully! Please sign in with your credentials.");
          setIsSignUp(false);
        }
      } else if (response.status === "FIELD_ERROR") {
        // Handle field errors
        const fieldErrors = response.formFields.map(field => 
          `${field.id}: ${field.error}`
        ).join(", ");
        setError(fieldErrors);
      } else {
        setError("Something went wrong. Please try again.");
      }
    } catch (err: any) {
      console.error("Sign up error:", err);
      setError(err.message || "Failed to create account");
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleSignIn = async () => {
    setGoogleLoading(true);
    setError('');
    
    try {
      const authUrl = await ThirdParty.getAuthorisationURLWithQueryParamsAndSetState({
        thirdPartyId: "google",
        frontendRedirectURI: `${import.meta.env.VITE_WEBSITE_DOMAIN}/login/callback/google`
      });
      
      window.location.href = authUrl;
    } catch (err: any) {
      setError("Failed to initiate Google sign in");
      console.error(err);
      setGoogleLoading(false);
    }
  };

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
      
      // Navigate to login page instead of reloading
      navigate('/login');
    } catch (error) {
      console.error('Error signing out:', error);
      // Even if there's an error, try to navigate to login
      navigate('/login');
    }
  };

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      <div class="flex-1 flex items-center justify-center">
        <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96 border border-slate-700">
          <h1 class="text-white text-3xl font-bold text-center mb-4">
            {isSignUp() ? 'Create Account' : 'Welcome Back'}
          </h1>

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
            <form onSubmit={isSignUp() ? handleSignUp : handleSignIn} class="space-y-4 mt-4">
              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1">Email</label>
                <input
                  type="email"
                  value={email()}
                  onInput={(e) => setEmail(e.currentTarget.value)}
                  required
                  class="w-full px-3 py-2 bg-slate-700 border border-slate-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1">Password</label>
                <input
                  type="password"
                  value={password()}
                  onInput={(e) => setPassword(e.currentTarget.value)}
                  required
                  class="w-full px-3 py-2 bg-slate-700 border border-slate-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              
              <Show when={isSignUp()}>
                <div>
                  <label class="block text-sm font-medium text-slate-300 mb-1">Name</label>
                  <input
                    type="text"
                    value={name()}
                    onInput={(e) => setName(e.currentTarget.value)}
                    required
                    class="w-full px-3 py-2 bg-slate-700 border border-slate-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </Show>
              
              <Show when={error()}>
                <p class="text-red-400 text-sm">{error()}</p>
              </Show>
              
              <button
                type="submit"
                disabled={loading()}
                class="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading() ? (
                  <span class="flex items-center justify-center">
                    <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Processing...
                  </span>
                ) : (
                  isSignUp() ? 'Create Account' : 'Sign In'
                )}
              </button>
              
              <div class="relative my-6">
                <div class="absolute inset-0 flex items-center">
                  <div class="w-full border-t border-slate-600"></div>
                </div>
                <div class="relative flex justify-center text-sm">
                  <span class="px-2 bg-slate-800 text-slate-400">Or continue with</span>
                </div>
              </div>
              
              <button
                type="button"
                onClick={handleGoogleSignIn}
                disabled={googleLoading()}
                class="w-full flex justify-center items-center py-2 px-4 border border-slate-600 rounded-md shadow-sm bg-slate-700 text-sm font-medium text-white hover:bg-slate-600 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {googleLoading() ? (
                  <span class="flex items-center justify-center">
                    <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Processing...
                  </span>
                ) : (
                  <>
                    <svg class="h-5 w-5 mr-2" viewBox="0 0 24 24">
                      <g transform="matrix(1, 0, 0, 1, 27.009001, -39.238998)">
                        <path fill="#4285F4" d="M -3.264 51.509 C -3.264 50.719 -3.334 49.969 -3.454 49.239 L -14.754 49.239 L -14.754 53.749 L -8.284 53.749 C -8.574 55.229 -9.424 56.479 -10.684 57.329 L -10.684 60.329 L -6.824 60.329 C -4.564 58.239 -3.264 55.159 -3.264 51.509 Z"/>
                        <path fill="#34A853" d="M -14.754 63.239 C -11.514 63.239 -8.804 62.159 -6.824 60.329 L -10.684 57.329 C -11.764 58.049 -13.134 58.489 -14.754 58.489 C -17.884 58.489 -20.534 56.379 -21.484 53.529 L -25.464 53.529 L -25.464 56.619 C -23.494 60.539 -19.444 63.239 -14.754 63.239 Z"/>
                        <path fill="#FBBC05" d="M -21.484 53.529 C -21.734 52.809 -21.864 52.039 -21.864 51.239 C -21.864 50.439 -21.724 49.669 -21.484 48.949 L -21.484 45.859 L -25.464 45.859 C -26.284 47.479 -26.754 49.299 -26.754 51.239 C -26.754 53.179 -26.284 54.999 -25.464 56.619 L -21.484 53.529 Z"/>
                        <path fill="#EA4335" d="M -14.754 43.989 C -12.984 43.989 -11.404 44.599 -10.154 45.789 L -6.734 42.369 C -8.804 40.429 -11.514 39.239 -14.754 39.239 C -19.444 39.239 -23.494 41.939 -25.464 45.859 L -21.484 48.949 C -20.534 46.099 -17.884 43.989 -14.754 43.989 Z"/>
                      </g>
                    </svg>
                    Continue with Google
                  </>
                )}
              </button>
              
              <div class="text-center mt-4">
                <button
                  type="button"
                  onClick={() => {
                    setIsSignUp(!isSignUp());
                    setError('');
                  }}
                  class="text-blue-400 hover:text-blue-300 text-sm"
                >
                  {isSignUp() ? 'Already have an account? Sign In' : 'Need an account? Sign Up'}
                </button>
              </div>
            </form>
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

export default Login; 