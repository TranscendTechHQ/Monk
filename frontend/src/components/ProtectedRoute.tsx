import { createEffect } from "solid-js";
import { useNavigate } from "@solidjs/router";
import Session from "supertokens-web-js/recipe/session";

const ProtectedRoute = (props: { children: any }) => {
  const navigate = useNavigate();
  
  createEffect(async () => {
    if (!await Session.doesSessionExist()) {
      navigate(import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH, { replace: true });
    }
  });

  return <>{props.children}</>;
};

export default ProtectedRoute;
