import React, { Component } from "react"
import I18n from "i18n-js";

export default class Header extends Component {
  render() {
    return (
        <div className="jumbotron-back card card-image mb-4">
          <section className="jumbotron-top text-center text-white py-5">
            <div className="container">
              <h1 className="jumbotron-heading">{I18n.t('application_title')}</h1>
              <p className="mb-4 pb-2 px-md-5 mx-md-5">{I18n.t('application_description')}</p>
            </div>
          </section>
        </div>
    );
  }
}