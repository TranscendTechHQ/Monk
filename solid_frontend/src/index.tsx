/* @refresh reload */
import { render } from "solid-js/web";
import { Router, Route } from "@solidjs/router";
import "./index.css";
import { Root } from './App';
import Login, { Auth } from "./Auth";
import { initSuperTokensWebJS } from "./config";
import ThreadMessages from './components/ThreadMessages';
import { UserProvider } from './context/UserContext';

initSuperTokensWebJS();

const root = document.getElementById("root");

render(
    () => (
        <UserProvider>
            <Router>
                <Route path="/auth/*" component={Auth} />
                <Route path="/login/*" component={Login} />
                <Route path="/" component={Root} />
                <Route path="/thread/:id" component={ThreadMessages} />
            </Router>
        </UserProvider>
    ),
    root!
);
