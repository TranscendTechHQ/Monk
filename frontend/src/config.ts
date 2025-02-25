/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */
import SuperTokens from "supertokens-web-js";
import Session from "supertokens-web-js/recipe/session";

const origin = window.location.origin;
//const apiDomain = import.meta.env.VITE_API_DOMAIN;
const apiDomain = origin + "/api";
const websiteDomain = origin;
//const websiteDomain = import.meta.env.VITE_WEBSITE_DOMAIN;

export function initSuperTokensUI() {
    console.log("initSuperTokensUI");
    
    (window as any).supertokensUIInit("supertokensui", {
        appInfo: {
            websiteDomain: String(websiteDomain),
            apiDomain: String(apiDomain),
            appName: "SuperTokens Demo App",
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
            appName: "SuperTokens Demo App",
            apiDomain: String(apiDomain),
        },
        recipeList: [Session.init()],
    });
}
