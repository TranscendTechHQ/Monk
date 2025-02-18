/* @refresh reload */
import { render } from "solid-js/web";
import { Router, Route } from "@solidjs/router";
import "./index.css";

import Login, { Auth } from "./Auth";
import { initSuperTokensWebJS } from "./config";
import ThreadMessages from './components/ThreadMessages';
import { UserProvider } from './context/UserContext';
import App from './App';

initSuperTokensWebJS();

const root = document.getElementById("root");

render(
    () => (
        <UserProvider>
            <App />
        </UserProvider>
    ),
    root!
);
