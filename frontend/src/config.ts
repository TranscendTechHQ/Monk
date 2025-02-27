import SuperTokens from "supertokens-web-js";
import Session from "supertokens-web-js/recipe/session";

const apiDomain = import.meta.env.VITE_API_DOMAIN;  
const websiteDomain = import.meta.env.VITE_WEBSITE_DOMAIN;  
const apiBasePath = import.meta.env.VITE_SUPERTOKENS_API_BASE_PATH;
const appName = import.meta.env.VITE_SUPERTOKENS_APP_NAME;
const websiteBasePath = import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH;

export function initSuperTokensUI() {
    //console.log("initSuperTokensUI");
    (window as any).supertokensUIInit("supertokensui", {
        appInfo: {
            websiteDomain: String(websiteDomain),  
            apiDomain: String(apiDomain),          
            appName: appName,
            apiBasePath: apiBasePath,              
            websiteBasePath: websiteBasePath               
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
    //console.log("initSuperTokensWebJS");
    //console.log("apiDomain", apiDomain);
    SuperTokens.init({
        appInfo: {
            appName: appName,
            apiDomain: String(apiDomain),  
            apiBasePath: apiBasePath,      
        },
        recipeList: [Session.init()],
    });
}