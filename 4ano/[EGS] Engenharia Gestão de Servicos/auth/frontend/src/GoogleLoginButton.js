import React from 'react';
import './GoogleLoginButton.css';
import googleLogo from './images/GoogleLogo.png';

function GoogleLoginButton() {
  function handleClick() {
    window.location.href = 'http://ridemate.duckdns.org/auth/google';
    //window.location.href = 'http://auth-backend:5100/google';
  }

  return ( 
    <button onClick={handleClick} className='GoogleLoginButton'>
      <img src={googleLogo} alt='Github'/>
      &nbsp;&nbsp;&nbsp;Login with Google
    </button>
  );
}

export default GoogleLoginButton;