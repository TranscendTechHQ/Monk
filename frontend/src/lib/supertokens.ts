import SuperTokens from "supertokens-web-js";
import EmailPassword from "supertokens-web-js/recipe/emailpassword";
import ThirdParty from "supertokens-web-js/recipe/thirdparty";
import Session from "supertokens-web-js/recipe/session";

export const initSuperTokens = () => {
  console.log("SuperTokens initialization started with config");

  try {
    SuperTokens.init({
      appInfo: {
        appName: import.meta.env.VITE_SUPERTOKENS_APP_NAME,
        apiDomain: import.meta.env.VITE_API_DOMAIN,
        apiBasePath: import.meta.env.VITE_SUPERTOKENS_API_BASE_PATH,
      },
      recipeList: [
        EmailPassword.init(),
        ThirdParty.init(),
        Session.init()
      ]
    });
    console.log("SuperTokens initialization completed successfully");
  } catch (err) {
    console.error("SuperTokens initialization failed:", err);
    throw err;
  }
}; 