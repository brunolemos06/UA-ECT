import React from 'react';
import GoogleLoginButton from './GoogleLoginButton';
import GithubLoginButton from './GithubLoginButton';

import './ButtonDiv.css';

function App() {
  return (
    <div className='ButtonDiv'>
        <div>
          <GoogleLoginButton />
        </div>
        <div>
          <GithubLoginButton />
        </div>
    </div>
  );
}

export default App;
