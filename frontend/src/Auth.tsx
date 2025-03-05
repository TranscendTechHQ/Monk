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
import Header from './components/Header';
import Footer from './components/Footer';

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
    const userContext = useUser();
    const [sessionExists, setSessionExists] = createSignal(false);
    const navigate = useNavigate();

    // Check for authentication before loading the auth UI
    onMount(async () => {
        const exists = await Session.doesSessionExist();
        setSessionExists(exists);
        
        if (exists) {
            console.log("Session already exists, user should log out first");
            // Refresh user data to ensure we have the latest info
            if (userContext) {
                await userContext.refreshUser();
            }
        } else {
            loadScript("https://cdn.jsdelivr.net/gh/supertokens/prebuiltui@v0.48.0/build/static/js/main.81589a39.js");
        }
    });

    // Check for authentication changes
    createEffect(async () => {
        const exists = await Session.doesSessionExist();
        setSessionExists(exists);
        
        if (exists && userContext) {
            // If session exists but we don't have user data, refresh it
            await userContext.refreshUser();
        }
    });

    const handleSignOut = async () => {
        try {
            // Sign out from SuperTokens
            await Session.signOut();
            
            // Clear the user context
            if (userContext) {
                userContext.setUser(null);
            }
            
            // Update session state
            setSessionExists(false);
            
            // Reload the page to reset everything
            window.location.reload();
        } catch (error) {
            console.error('Error signing out:', error);
        }
    };

    return (
        <div class="h-screen flex flex-col bg-slate-900 text-white">
            <Header />
            
            <div class="flex-1 flex items-center justify-center">
                <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96 border border-slate-700">
                    <Show 
                        when={!sessionExists()} 
                        fallback={
                            <div class="text-center space-y-4">
                                <h2 class="text-white text-2xl font-semibold text-center mb-6">
                                    You are already logged in
                                </h2>
                                <p class="text-slate-300 mb-4">
                                    You need to log out before creating a new account.
                                </p>
                                <Show when={userContext?.user()}>
                                    <div class="bg-slate-700 p-4 rounded-lg mb-4">
                                        <p class="text-white">Currently logged in as:</p>
                                        <p class="text-white font-bold">{userContext?.user()?.name}</p>
                                        <p class="text-slate-300">{userContext?.user()?.email}</p>
                                    </div>
                                </Show>
                                <button 
                                    onClick={handleSignOut} 
                                    class="w-full bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700 transition duration-200"
                                >
                                    Sign Out
                                </button>
                                <button
                                    onClick={() => navigate('/newsfeed')}
                                    class="w-full border border-slate-600 text-white bg-slate-700 hover:bg-slate-600 transition duration-200 py-2 px-4 rounded mt-2"
                                >
                                    Back to NewsFeed
                                </button>
                            </div>
                        }
                    >
                        <h2 class="text-white text-2xl font-semibold text-center mb-6">Login</h2>
                        <div id="supertokensui" />
                    </Show>
                </div>
            </div>
            
            <Footer />
        </div>
    );
};

async function getUserInfo() {
    const session = await Session.doesSessionExist();
    if (session) {
        const userId = await Session.getUserId();
        return { userId, session };
    }
    return { userId: null, session: false };
}

async function signOut() {
    try {
        // Sign out from SuperTokens
        await Session.signOut();
        
        // Force a complete page reload to clear all state
        window.location.href = '/login';
    } catch (error) {
        console.error('Error signing out:', error);
        // If there's an error, still try to reload the page
        window.location.reload();
    }
}

function redirectToSignIn() {
    window.location.href = import.meta.env.VITE_SUPERTOKENS_WEBSITE_BASE_PATH;
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
        
        // If session exists, make sure user data is refreshed
        if (session && userContext) {
            await userContext.refreshUser();
        }
    });

    const handleSignOut = async () => {
        try {
            // Sign out from SuperTokens
            await Session.signOut();
            
            // Clear the user context
            if (userContext) {
                userContext.setUser(null);
            }
            
            // Update session state
            setData({ userId: null, session: false });
            
            // Reload the page to reset everything
            window.location.reload();
        } catch (error) {
            console.error('Error signing out:', error);
        }
    };

    return (
        <div class="h-screen flex flex-col bg-slate-900 text-white">
            <Header />
            
            <div class="flex-1 flex items-center justify-center">
                <div class="bg-slate-800 p-8 rounded-lg shadow-lg w-96 border border-slate-700">
                    <h1 class="text-white text-3xl font-bold text-center mb-4">Hello!</h1>

                    <Show when={data().session}>
                        <div class="text-center space-y-4">
                            <Show 
                                when={user()} 
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
                                <p class="text-slate-300">
                                    {user()!.email}
                                </p>
                            </Show>
                            <button
                                onClick={() => navigate('/newsfeed')}
                                class="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200"
                            >
                                Go to NewsFeed
                            </button>
                            <button 
                                onClick={handleSignOut} 
                                class="w-full border border-slate-600 text-white bg-slate-700 hover:bg-slate-600 transition duration-200 py-2 px-4 rounded"
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
                            class="w-full mt-4 bg-blue-600 text-white hover:bg-blue-700 transition duration-200 py-2 px-4 rounded"
                        >
                            Sign in
                        </button>
                    </Show>
                </div>
            </div>
            
            <Footer />
        </div>
    );
}

export default Login;
