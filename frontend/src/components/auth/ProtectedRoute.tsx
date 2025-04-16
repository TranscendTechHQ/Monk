import { createSignal, createEffect, onMount, Show } from "solid-js";
import { useNavigate } from "@solidjs/router";
import Session from "supertokens-web-js/recipe/session";

export default function ProtectedRoute(props) {
  const [loading, setLoading] = createSignal(true);
  const [isAuthenticated, setIsAuthenticated] = createSignal(false);
  const navigate = useNavigate();

  onMount(async () => {
    try {
      const doesSessionExist = await Session.doesSessionExist();
      setIsAuthenticated(doesSessionExist);
      if (!doesSessionExist) {
        navigate("/login", { replace: true });
      }
    } catch (err) {
      console.error(err);
      navigate("/login", { replace: true });
    } finally {
      setLoading(false);
    }
  });

  return (
    <Show when={!loading()} fallback={<div class="flex justify-center items-center h-screen">Loading...</div>}>
      <Show when={isAuthenticated()}>
        {props.children}
      </Show>
    </Show>
  );
} 