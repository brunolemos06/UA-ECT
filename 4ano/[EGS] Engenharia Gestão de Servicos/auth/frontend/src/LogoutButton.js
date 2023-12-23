import React from 'react';
import './LogoutButton.css';

function LogoutButton() {
  function handleClick() {
    window.location.href = 'http://10.0.2.2:5100/logout';
  }

  return ( 
    <button onClick={handleClick} className='LogoutButton'>
      Logout
    </button>
  );
}

export default LogoutButton;