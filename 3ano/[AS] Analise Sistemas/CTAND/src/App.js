import './App.css';
import React from 'react';
import {BrowserRouter as Router, Routes,Route} from 'react-router-dom'

import Home from './pages/Home.js';
import Login from './pages/Login';
import Profile from './pages/Profile.js';
import Sellcar from './pages/Sellcar.js';
import AgentPage from './pages/AgentPage.js';
function App() {

  const [user, setUser] = React.useState("");
  const [loggedIn, setLoggedIn] = React.useState(false);

  return (
    <div className="App">
      <Router>
        <Routes>
          <Route exact path="/" element={<Home user={user} loggedIn={loggedIn}/>} />
          <Route exact path="/login" element={<Login setUser={setUser} setLoggedIn={setLoggedIn}/>} />
          <Route exact path="/profile" element={<Profile user={user}  setUser={setUser} setLoggedIn={setLoggedIn} loggedIn={loggedIn}/>} />
          <Route exact path="/Sellcar" element={<Sellcar loggedIn={loggedIn} user={user}/>} />
          <Route exact path="/agent" element={<AgentPage setUser={setUser} loggedIn={loggedIn} user={user} setLoggedIn={setLoggedIn}/>} />
        </Routes>
      </Router>
      
    </div>
  );
}

export default App;
