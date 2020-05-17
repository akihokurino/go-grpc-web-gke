import React from "react";
import logo from "./logo.svg";
import "./App.css";
// import { HelloClient } from "./rpc/hello_pb_service";
// import { Empty } from "./rpc/hello_pb";

function App() {
  React.useEffect(() => {
    // const client = new HelloClient("http://localhost:3000/server");
    // const req = new Empty();
    // client.world(req, (err, res) => {
    //   console.log(err);
    //   console.log(res);
    // });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
