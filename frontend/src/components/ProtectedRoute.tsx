import { createEffect } from "solid-js";
import { useNavigate } from "@solidjs/router";
import Session from "supertokens-web-js/recipe/session";
import { useUser } from "../context/UserContext";

const ProtectedRoute = (props: { children: any }) => {
  const navigate = useNavigate();
  const userContext = useUser();
  
  createEffect(async () => {
    const sessionExists = await Session.doesSessionExist();
    
    if (!sessionExists) {
      // Redirect to login if no session exists
      navigate(import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH, { replace: true });
    } else if (userContext) {
      // If session exists but we don't have user data, refresh it
      if (!userContext.user()) {
        console.log("Protected route: Session exists but no user data, refreshing...");
        await userContext.refreshUser();
      }
    }
  });

  return <>{props.children}</>;
};

export default ProtectedRoute;
