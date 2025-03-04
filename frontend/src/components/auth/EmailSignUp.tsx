import { createSignal, Show } from "solid-js";
import EmailPassword from "supertokens-web-js/recipe/emailpassword";
import { useNavigate } from "@solidjs/router";

export default function EmailSignUp() {
  const [email, setEmail] = createSignal("");
  const [password, setPassword] = createSignal("");
  const [name, setName] = createSignal("");
  const [error, setError] = createSignal("");
  const [loading, setLoading] = createSignal(false);
  const navigate = useNavigate();

  const handleSignUp = async (e: Event) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const response = await EmailPassword.signUp({
        formFields: [
          { id: "email", value: email() },
          { id: "password", value: password() },
          { id: "name", value: name() }
        ]
      });

      if (response.status === "FIELD_ERROR") {
        // Handle field errors
        const fieldErrors = response.formFields.map(field => 
          `${field.id}: ${field.error}`
        ).join(", ");
        setError(fieldErrors);
      } else if (response.status === "OK") {
        // Redirect to home page instead of dashboard
        navigate("/");
      }
    } catch (err) {
      setError("An error occurred during sign up");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div class="w-full max-w-md">
      <form onSubmit={handleSignUp} class="bg-white shadow-md rounded-lg px-8 pt-6 pb-8 mb-4">
        <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Sign Up</h2>
        
        <Show when={error()}>
          <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-md">
            {error()}
          </div>
        </Show>

        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="name">
            Name
          </label>
          <input
            id="name"
            type="text"
            value={name()}
            onInput={(e) => setName(e.currentTarget.value)}
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="John Doe"
          />
        </div>

        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
            Email
          </label>
          <input
            id="email"
            type="email"
            value={email()}
            onInput={(e) => setEmail(e.currentTarget.value)}
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="email@example.com"
            required
          />
        </div>

        <div class="mb-6">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
            Password
          </label>
          <input
            id="password"
            type="password"
            value={password()}
            onInput={(e) => setPassword(e.currentTarget.value)}
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="********"
            required
          />
          <p class="text-xs text-gray-500 mt-1">Must be at least 8 characters</p>
        </div>

        <div class="flex items-center justify-center">
          <button
            type="submit"
            disabled={loading()}
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline w-full"
          >
            {loading() ? "Signing up..." : "Sign Up"}
          </button>
        </div>
      </form>
    </div>
  );
} 