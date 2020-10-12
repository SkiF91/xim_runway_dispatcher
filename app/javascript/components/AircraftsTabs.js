import React, {Component} from "react";
import Aircrafts from "../components/Aircrafts";
import {createConsumer} from "@rails/actioncable";


export default class AircraftsTabs extends Component {
  constructor() {
    super()
    this.state = {
      needLoadHistory: false,
      wsMessage: null
    }

    this.loadHistoryTab = this.loadHistoryTab.bind(this)
    this.handleReceivedMessage = this.handleReceivedMessage.bind(this)
    this.cable = createConsumer('/dispatcher')
  }

  componentDidMount() {
    this.initWebSocket()
  }

  initWebSocket() {
    this.cable.subscriptions.create('AircraftsChannel',
        { received: message => this.handleReceivedMessage(message) }
    )
  }

  loadHistoryTab() {
    this.setState({ needLoadHistory: true });
  }

  handleReceivedMessage(message) {
    console.log(message)
    this.setState({wsMessage: message})
  }

  render() {
    return (
        <>
          <p className="h3">{I18n.t('aircrafts_header')}</p>

          <ul className="nav nav-tabs" role="tablist">
            <li className="nav-item" role="presentation">
              <a className="nav-link active" data-toggle="tab" href="#active-aircrafts" role="tab"
                aria-selected="true">{I18n.t('aircraft_active')}</a>
            </li>
            <li className="nav-item" role="presentation">
              <a className="nav-link" data-toggle="tab" href="#inactive-aircrafts" role="tab"
                aria-selected="false" onClick={this.loadHistoryTab}>{I18n.t('aircraft_history')}</a>
            </li>
          </ul>
          <div className="tab-content">
            <div className="tab-pane fade show active pt-3" id="active-aircrafts" role="tabpanel">
              <Aircrafts load={true} history={false} wsMessage={this.state.wsMessage} />
            </div>
            <div className="tab-pane fade pt-3" id="inactive-aircrafts" role="tabpanel">
              <Aircrafts load={this.state.needLoadHistory} history={true} wsMessage={this.state.wsMessage} />
            </div>
          </div>
        </>
    )
  }
}