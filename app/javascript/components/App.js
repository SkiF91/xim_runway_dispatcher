import React, { Component } from "react"
import Header from '../components/Header';
import AircraftsTabs from "../components/AircraftsTabs";

class App extends Component {
  render() {
    return (
        <div className="container my-4">
          <Header />
          <AircraftsTabs />
        </div>
    );
  }
}
export default App;