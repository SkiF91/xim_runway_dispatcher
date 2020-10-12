import React, {Component} from "react"
import LoadingSpinner from "../components/LoadingSpinner"
import AircraftHistory from "../components/AircraftHistory"
import {makeFetch} from "../utils"

export default class Aircrafts extends Component {
  constructor(props) {
    super(props)
    this.state = {
      aircraft: props.aircraft,
      history: [],
      historyLoaded: false,
      showHistory: false,
      loading: false
    }

    this.toggleHistory = this.toggleHistory.bind(this);
  }

  setAircraftState(data) {
    var history = this.state.history
    history.push(data.history)
    this.setState({aircraft: data.aircraft, history: history})
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    if (prevProps.aircraft && prevProps.aircraft.status.id != this.props.aircraft.status.id) {
      this.setAircraftState({aircraft: this.props.aircraft, history: this.props.aircraft.lastHistory })
    }
  }

  makeFetch(action, method, callback) {
    this.setState({loading: true})

    return makeFetch(`/aircrafts/${this.props.aircraft.id}/${action}`, method, callback)
        .finally(() => this.setState({loading: false}))
  }

  handleChangeStatus(e, action) {
    e.preventDefault()
    this.makeFetch(action, 'post', result => {
      if (result) {
        this.setAircraftState(result)
      }
    })
  }

  toggleHistory(e) {
    e.preventDefault()
    if (this.state.loading) {
      return;
    }
    if (this.state.historyLoaded) {
      this.setState({showHistory: !this.state.showHistory})
    } else {
      this.setState({loading: true})

      this.makeFetch('history', 'get', result => {
        this.setState({history: result || [], historyLoaded: true, showHistory: !this.state.showHistory})
      })
    }
  }

  renderButtons() {
    var result = (<></>)

    if (this.state.loading) {
      result = <LoadingSpinner small={true}/>
    } else {
      if (this.state.aircraft.status.can_send) {
        result = (<>{result}
          <button className="btn btn-success btn-sm"
                  onClick={(e) => this.handleChangeStatus(e, 'to_runway')}>{I18n.t('button_to_runway')}</button>
        </>)
      }

      if (this.state.aircraft.status.can_cancel) {
        result = (<>{result}
          <button className="btn btn-danger btn-sm"
                  onClick={(e) => this.handleChangeStatus(e, 'cancel')}>{I18n.t('button_cancel')}</button>
        </>)
      }

      result = (<>{result}
        <button className="btn btn-primary btn-sm"
                onClick={this.toggleHistory}>{this.state.showHistory ? I18n.t('hide_history') : I18n.t('show_history')}</button>
      </>)
    }

    return result
  }

  renderHistory() {
    return (this.state.showHistory ?
        <AircraftHistory aircraft={this.props.aircraft} history={this.state.history}/> : <></>)
  }

  render() {
    return (
        <>
          <tr key={this.props.aircraft.id}>
            <td scope="row">{this.props.aircraft.id}</td>
            <td>{this.props.aircraft.name}</td>
            <td>{this.state.aircraft.status.caption}</td>
            <td className="buttons-cell">
              {this.renderButtons()}
            </td>
          </tr>
          {this.renderHistory()}
        </>
    )
  }
}