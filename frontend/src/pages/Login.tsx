import { createSignal, Show, onMount } from "solid-js";
import { useNavigate } from "@solidjs/router";
import EmailPassword from "supertokens-web-js/recipe/emailpassword";
import ThirdParty from "supertokens-web-js/recipe/thirdparty";
import Session from "supertokens-web-js/recipe/session";
import SuperTokens from "supertokens-web-js";
import { initSuperTokens } from "../lib/supertokens";

export default function Login() {
  const [isSignUp, setIsSignUp] = createSignal(false);
  const [email, setEmail] = createSignal("");
  const [password, setPassword] = createSignal("");
  const [name, setName] = createSignal("");
  const [error, setError] = createSignal("");
  const [loading, setLoading] = createSignal(false);
  const navigate = useNavigate();



  const handleEmailAuth = async (e: Event) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      if (isSignUp()) {
        // Sign up flow
        console.log("Attempting to sign up with email:", email());
        const response = await EmailPassword.signUp({
          formFields: [
            { id: "email", value: email() },
            { id: "password", value: password() },
            { id: "name", value: name() }
          ]
        });

        console.log("Sign up response:", response);
        if (response.status === "FIELD_ERROR") {
          const fieldErrors = response.formFields.map(field => 
            `${field.id}: ${field.error}`
          ).join(", ");
          setError(fieldErrors);
        } else if (response.status === "OK") {
          navigate("/newsfeed");
        }
      } else {
        // Sign in flow
        console.log("Attempting to sign in with email:", email());
        const response = await EmailPassword.signIn({
          formFields: [
            { id: "email", value: email() },
            { id: "password", value: password() }
          ]
        });

        console.log("Sign in response:", response);
        if (response.status === "FIELD_ERROR") {
          const fieldErrors = response.formFields.map(field => 
            `${field.id}: ${field.error}`
          ).join(", ");
          setError(fieldErrors);
        } else if (response.status === "WRONG_CREDENTIALS_ERROR") {
          setError("Invalid email or password");
        } else if (response.status === "OK") {
          navigate("/newsfeed");
        }
      }
    } catch (err: any) {
      console.error("Error during email authentication:", err);
      if (err.message && err.message.includes("No instance of EmailPassword found")) {
        setError("Email authentication is not properly configured. Please try using Google sign-in instead.");
      } else {
        setError(`An error occurred: ${err?.message || "Unknown error"}`);
      }
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleSignIn = async () => {
    try {
      console.log("Initiating Google sign in");
      window.location.href = `${import.meta.env.VITE_API_DOMAIN}${import.meta.env.VITE_SUPERTOKENS_API_BASE_PATH}/authorisation/google?redirectToPath=${encodeURIComponent(import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH)}`;
    } catch (err: any) {
      console.error("Error initiating Google sign in:", err);
      setError(`Failed to initiate Google sign in: ${err?.message || "Unknown error"}`);
    }
  };

  return (
    <div class="min-h-screen bg-slate-900 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="mt-6 text-center text-3xl font-extrabold text-white">
          {isSignUp() ? "Create your account" : "Sign in to your account"}
        </h2>
        <p class="mt-2 text-center text-sm text-slate-400">
          {isSignUp() ? "Already have an account? " : "Don't have an account? "}
          <button
            onClick={() => setIsSignUp(!isSignUp())}
            class="font-medium text-blue-400 hover:text-blue-300"
          >
            {isSignUp() ? "Sign in" : "Sign up"}
          </button>
        </p>
      </div>

      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="bg-slate-800 py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <form onSubmit={handleEmailAuth} class="space-y-6">
            <Show when={error()}>
              <div class="rounded-md bg-red-900/50 p-4">
                <div class="text-sm text-red-400">{error()}</div>
              </div>
            </Show>

            <Show when={isSignUp()}>
              <div>
                <label for="name" class="block text-sm font-medium text-slate-300">
                  Name
                </label>
                <div class="mt-1">
                  <input
                    id="name"
                    name="name"
                    type="text"
                    value={name()}
                    onInput={(e) => setName(e.currentTarget.value)}
                    class="appearance-none block w-full px-3 py-2 border border-slate-600 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-slate-700 text-white sm:text-sm"
                    placeholder="John Doe"
                  />
                </div>
              </div>
            </Show>

            <div>
              <label for="email" class="block text-sm font-medium text-slate-300">
                Email address
              </label>
              <div class="mt-1">
                <input
                  id="email"
                  name="email"
                  type="email"
                  autocomplete="email"
                  required
                  value={email()}
                  onInput={(e) => setEmail(e.currentTarget.value)}
                  class="appearance-none block w-full px-3 py-2 border border-slate-600 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-slate-700 text-white sm:text-sm"
                  placeholder="you@example.com"
                />
              </div>
            </div>

            <div>
              <label for="password" class="block text-sm font-medium text-slate-300">
                Password
              </label>
              <div class="mt-1">
                <input
                  id="password"
                  name="password"
                  type="password"
                  autocomplete={isSignUp() ? "new-password" : "current-password"}
                  required
                  value={password()}
                  onInput={(e) => setPassword(e.currentTarget.value)}
                  class="appearance-none block w-full px-3 py-2 border border-slate-600 rounded-md shadow-sm placeholder-slate-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-slate-700 text-white sm:text-sm"
                  placeholder="••••••••"
                />
              </div>
              <Show when={isSignUp()}>
                <p class="mt-1 text-xs text-slate-500">Must be at least 8 characters</p>
              </Show>
            </div>

            <div>
              <button
                type="submit"
                disabled={loading()}
                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading() ? "Processing..." : isSignUp() ? "Sign up" : "Sign in"}
              </button>
            </div>
          </form>

          <div class="mt-6">
            <div class="relative">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-slate-600"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-slate-800 text-slate-400">
                  Or continue with
                </span>
              </div>
            </div>

            <div class="mt-6">
              <button
                onClick={handleGoogleSignIn}
                class="w-full flex justify-center items-center py-2 px-4 border border-slate-600 rounded-md shadow-sm bg-slate-700 text-sm font-medium text-white hover:bg-slate-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                <svg class="h-5 w-5 mr-2" viewBox="0 0 24 24">
                  <g transform="matrix(1, 0, 0, 1, 27.009001, -39.238998)">
                    <path fill="#4285F4" d="M -3.264 51.509 C -3.264 50.719 -3.334 49.969 -3.454 49.239 L -14.754 49.239 L -14.754 53.749 L -8.284 53.749 C -8.574 55.229 -9.424 56.479 -10.684 57.329 L -10.684 60.329 L -6.824 60.329 C -4.564 58.239 -3.264 55.159 -3.264 51.509 Z"/>
                    <path fill="#34A853" d="M -14.754 63.239 C -11.514 63.239 -8.804 62.159 -6.824 60.329 L -10.684 57.329 C -11.764 58.049 -13.134 58.489 -14.754 58.489 C -17.884 58.489 -20.534 56.379 -21.484 53.529 L -25.464 53.529 L -25.464 56.619 C -23.494 60.539 -19.444 63.239 -14.754 63.239 Z"/>
                    <path fill="#FBBC05" d="M -21.484 53.529 C -21.734 52.809 -21.864 52.039 -21.864 51.239 C -21.864 50.439 -21.724 49.669 -21.484 48.949 L -21.484 45.859 L -25.464 45.859 C -26.284 47.479 -26.754 49.299 -26.754 51.239 C -26.754 53.179 -26.284 54.999 -25.464 56.619 L -21.484 53.529 Z"/>
                    <path fill="#EA4335" d="M -14.754 43.989 C -12.984 43.989 -11.404 44.599 -10.154 45.789 L -6.734 42.369 C -8.804 40.429 -11.514 39.239 -14.754 39.239 C -19.444 39.239 -23.494 41.939 -25.464 45.859 L -21.484 48.949 C -20.534 46.099 -17.884 43.989 -14.754 43.989 Z"/>
                  </g>
                </svg>
                Continue with Google
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 