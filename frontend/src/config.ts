import SuperTokens from "supertokens-web-js";
import Session from "supertokens-web-js/recipe/session";

const apiDomain = import.meta.env.VITE_API_DOMAIN;  // https://localhost from Dockerfile
const websiteDomain = import.meta.env.VITE_WEBSITE_DOMAIN;  // https://localhost
const apiBasePath = "/api/auth";
const appName = "Monk";

export function initSuperTokensUI() {
    console.log("initSuperTokensUI");
    (window as any).supertokensUIInit("supertokensui", {
        appInfo: {
            websiteDomain: String(websiteDomain),  // https://localhost
            apiDomain: String(apiDomain),          // https://localhost
            appName: appName,
            apiBasePath: apiBasePath,              // /api/auth
            websiteBasePath: "/auth"               // Added for UI routes
        },
        recipeList: [
            (window as any).supertokensUIThirdParty.init({
                signInAndUpFeature: {
                    providers: [
                        (window as any).supertokensUIThirdParty.Google.init(),
                    ],
                },
            }),
            (window as any).supertokensUIPasswordless.init({
                contactMethod: "EMAIL_OR_PHONE",
            }),
            (window as any).supertokensUISession.init(),
        ],
    });
}

export function initSuperTokensWebJS() {
    console.log("initSuperTokensWebJS");
    console.log("apiDomain", apiDomain);
    SuperTokens.init({
        appInfo: {
            appName: appName,
            apiDomain: String(apiDomain),  // https://localhost
            apiBasePath: apiBasePath,      // /api/auth
        },
        recipeList: [Session.init()],
    });
}