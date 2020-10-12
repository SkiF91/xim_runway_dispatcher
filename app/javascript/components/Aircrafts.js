import React, {Component} from "react"
import Aircraft from "../components/Aircraft"
import LoadingSpinner from "../components/LoadingSpinner"
import {makeFetch} from "../utils"

export default class Aircrafts extends Component {

  constructor() {
    super()
    this.state = {
      aircrafts: [],
      loading: false,
      loadingAdd: false
    }
    this.handleAddAircraft = this.handleAddAircraft.bind(this);
  }

  loadData() {
    if (this.props.load) {
      this.setState({loading: true});

      fetch('/aircrafts' + (this.props.history ? '?history=1' : ''))
          .then(resp => resp.ok ? resp : Promise.reject(res))
          .then(resp => resp.json())
          .then(result => {
            this.setState({
              aircrafts: result,
              loading: false
            })
          })
          .catch(() => {
            this.setState({loading: false});
          })
    }
  }

  componentDidMount() {
    this.loadData();
  }

  componentDidUpdate(prevProps) {
    if (!prevProps.load && this.props.load) {
      this.loadData();
    }

    if (this.props.wsMessage && this.props.wsMessage !== prevProps.wsMessage) {
      this.handleWsMessage(this.props.wsMessage)
    }
  }

  handleWsMessage(message) {
    var aircrafts = [...this.state.aircrafts]
    var ind = aircrafts.findIndex(it => it.id == message.aircraft.id)
    var aircraft = ind < 0 ? null : aircrafts[ind]

    if (!message.aircraft.status.active && aircraft && aircraft.status.active) {
      aircrafts.splice(ind, 1);
    } else if (!message.aircraft.status.active && !aircraft) {
      aircrafts.push(message.aircraft)
    } else if (aircraft) {
      aircrafts[ind] = message.aircraft
    } else {
      return
    }
    message.aircraft.lastHistory = message.history
    this.setState({aircrafts: aircrafts});
  }

  handleAddAircraft(e) {
    e.preventDefault()
    this.setState({loadingAdd: true})
    makeFetch('/aircrafts', 'POST', (data) => {
      this.state.aircrafts.push(data)
    }).finally(() => this.setState({loadingAdd: false}))
  }

  render() {
    var addBtn = (<></>)
    if (!this.props.history) {
      if (this.state.loadingAdd) {
        addBtn = <LoadingSpinner small={true}/>
      } else {
        addBtn = <button className="btn btn-warning"
                         onClick={this.handleAddAircraft}>{I18n.t('button_add_aircraft')}</button>
      }
    }

    if (this.state.loading) {
      return <LoadingSpinner align="center"/>
    } else if (!this.state.aircrafts || !this.state.aircrafts.length) {
      return (
          <div className="alert alert-warning" role="alert">
            {I18n.t('label_no_aircrafts')}
            <p className="mt-3">{addBtn}</p>
          </div>
      );
    } else {
      return (
          <>
            <div className="mb-3">
              {addBtn}
            </div>
            <div className="table-responsive">
              <table className="table table-hover table-bordered">
                <thead>
                <tr key={0}>
                  <th scope="col">{I18n.t('field_id')}</th>
                  <th scope="col">{I18n.t('field_name')}</th>
                  <th scope="col">{I18n.t('field_status')}</th>
                  <th scope="col"/>
                </tr>
                </thead>
                <tbody>
                {this.state.aircrafts.map((aircraft) => {
                  return (
                      <Aircraft key={aircraft.id} aircraft={aircraft}/>
                  )
                })}
                </tbody>
              </table>
            </div>
          </>
      );
    }
  }
}