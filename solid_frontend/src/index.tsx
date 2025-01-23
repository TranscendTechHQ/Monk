/* @refresh reload */
import { render } from "solid-js/web";
import { Router, Route } from "@solidjs/router";
import "./index.css";
import App from "./App";
import Login, { Auth } from "./Auth";
import { initSuperTokensWebJS } from "./config";
import ThreadDetail from './components/ThreadDetail';
import { UserProvider } from './context/UserContext';

initSuperTokensWebJS();

const root = document.getElementById("root");

render(
    () => (
        <UserProvider>
            <Router>
                <Route path="/auth/*" component={Auth} />
                <Route path="/login/*" component={Login} />
                <Route path="/" component={App} />
                <Route path="/thread/:id" component={ThreadDetail} />
            </Router>
        </UserProvider>
    ),
    root!
);
