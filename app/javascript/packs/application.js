// require("@rails/ujs").start()
// require("@rails/activestorage").start()
// require("channels")

import I18n from "i18n-js";

global.I18n = I18n;

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

import React from "react";
import { render } from "react-dom";
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import "bootstrap/dist/css/bootstrap.min.css";
import $ from "jquery";
import "bootstrap/dist/js/bootstrap.bundle.min";
import App from "../components/App";

document.addEventListener("DOMContentLoaded", () => {
  render((
      <BrowserRouter>
        <Switch>
          <Route exact path="/" component={App}/>
        </Switch>
      </BrowserRouter>
  ), document.getElementById('content'));
});