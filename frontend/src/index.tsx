/* @refresh reload */
import { render } from "solid-js/web";
import App from './App';
import { Router, Route } from "@solidjs/router";
import "./index.css";


import ThreadMessages from './components/ThreadMessages';
import { UserProvider } from './context/UserContext';


//initSuperTokensWebJS();

const root = document.getElementById("root");

render(
    () => (
        <UserProvider>
            <App />
        </UserProvider>
    ),
    root!
);
