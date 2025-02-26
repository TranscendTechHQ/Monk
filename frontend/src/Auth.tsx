/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */



import { onMount, createEffect } from "solid-js";
import { initSuperTokensUI } from "./config";
import { Component } from 'solid-js';
import { createSignal, Show } from "solid-js";
import * as Session from "supertokens-web-js/recipe/session";
import { useHref, useNavigate } from "@solidjs/router";
import { useUser } from './context/UserContext';

const loadScript = (src: string) => {
    const script = document.createElement("script");
    script.type = "text/javascript";
    script.src = src;
    script.id = "supertokens-script";
    script.onload = () => {
        initSuperTokensUI();
    };
    document.body.appendChild(script);
};

export const Auth: Component = () => {
    onMount(() => {
        loadScript("https://cdn.jsdelivr.net/gh/supertokens/prebuiltui@v0.48.0/build/static/js/main.81589a39.js");
    });

    return (
        <div class="flex items-center justify-center min-h-screen bg-slate-900">
            <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96">
                <h2 class="text-white text-2xl font-semibold text-center mb-6">Login</h2>
                <div id="supertokensui" />
            </div>
        </div>
    );
};

async function getUserInfo() {
    console.log("getUserInfo");
    const session = await Session.doesSessionExist();
    console.log("session", session);
    if (session) {
        const userId = await Session.getUserId();
        return { userId, session };
    }
    return { userId: null, session: false };
}

async function signOut() {
    await Session.signOut();
    window.location.reload();
}

function redirectToSignIn() {
    console.log("redirectToSignIn");
    window.location.href = "/auth";
}

function Login() {
    const [data, setData] = createSignal<{
        userId: string | null;
        session: boolean;
    }>({
        userId: null,
        session: false,
    });

    const navigate = useNavigate();
    const userContext = useUser();
    const user = () => userContext?.user?.() || null;

    onMount(async () => {
        const { userId, session } = await getUserInfo();
        setData({ userId, session });
    });

    return (
        <main class="flex flex-col items-center justify-center min-h-screen bg-slate-900">
            <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96">
                <h1 class="text-white text-3xl font-bold text-center mb-4">Hello!</h1>

                <Show when={data().session}>
                    <div class="text-center space-y-4">
                        <Show 
                            when={user()?.name} 
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
                        </Show>
                        <button
                            onClick={() => navigate('/newsfeed')}
                            class="w-full bg-slate-600 text-white py-2 px-4 rounded hover:bg-slate-500 transition duration-200"
                        >
                            Go to NewsFeed
                        </button>
                        <button 
                            onClick={signOut} 
                            class="w-full border border-slate-400 text-white bg-slate-800 hover:bg-slate-700 transition duration-200 py-2 px-4 rounded"
                        >
                            Sign Out
                        </button>
                    </div>
                </Show>

                <Show when={!data().session}>
                    <p class="text-slate-300 text-center mt-4">
                        Please sign in to continue
                    </p>
                    <button 
                        onClick={redirectToSignIn} 
                        class="w-full mt-4 border border-slate-400 text-white bg-slate-800 hover:bg-slate-700 transition duration-200 py-2 px-4 rounded"
                    >
                        Sign in
                    </button>
                </Show>
            </div>
        </main>
    );
}

export default Login;
