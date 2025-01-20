/* @refresh reload */
import { render } from "solid-js/web";
import { Router, Route } from "@solidjs/router";
import "./index.css";
import App from "./App";
import Login, { Auth } from "./Auth";
import { initSuperTokensWebJS } from "./config";
import ThreadDetail from './components/ThreadDetail';

initSuperTokensWebJS();

const root = document.getElementById("root");

render(
    () => (
        <Router>
            <Route path="/auth/*" component={Auth} />
            <Route path="/login/*" component={Login} />
            <Route path="/" component={App} />
            <Route path="/thread/:id" component={ThreadDetail} />
        </Router>
    ),
    root!
);
