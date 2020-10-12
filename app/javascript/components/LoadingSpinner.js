import React, {Component} from "react"

export default class LoadingSpinner extends Component {
  render() {
    var spinner = (<div className={`spinner-border ${this.props.small ? 'spinner-border-sm' : ''}`} role="status" />)
    if (this.props.align == 'center') {
      return (
          <div className="d-flex justify-content-center">
            {spinner}
          </div>
      )
    } else {
      return spinner
    }
  }
}