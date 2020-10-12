import React, {Component} from "react"

export default class AircraftHistory extends Component {
  render() {
    return (
        <>
          {this.props.history.map((it) => {
            return (
                <tr key={`history-${this.props.aircraft.id}-${it.id}`}>
                  <td colSpan="2"/>
                  <td>{it.status.caption}</td>
                  <td>{I18n.strftime(new Date(it.created_at), I18n.t('date_time_format'))}</td>
                </tr>
            )
          })}
        </>
    )
  }
}