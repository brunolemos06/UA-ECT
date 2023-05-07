import React from "react";
import Navbar from "../components/Navbar";
import'./Login.css'
import {Link, useNavigate} from 'react-router-dom';
import { Icon } from '@iconify/react';



function Login ({loggedIn, setLoggedIn, setUser}) {

    let navigate = useNavigate();

    const handleLogin = (e) => {

        if(document.getElementById('username').value === "user" && document.getElementById('password').value === "user"){
            e.preventDefault();
            // setLoggedIn(true);
            // redirect to /profile using Navigate 
            setUser("user");
            setLoggedIn(true);
            navigate(`/profile`);

        } else if (document.getElementById('username').value === "seller" && document.getElementById('password').value === "seller"){
            e.preventDefault();
            // setLoggedIn(true);
            // redirect to /profile using Navigate 
            setUser("seller");
            setLoggedIn(true);
            navigate(`/profile`);
        } else if (document.getElementById('username').value === "agent" && document.getElementById('password').value === "agent"){
            e.preventDefault();
            // setLoggedIn(true);
            // redirect to /profile using Navigate 
            setUser("agent");
            setLoggedIn(true);
            navigate(`/agent`);
        } else if (document.getElementById('username').value === "admin" && document.getElementById('password').value === "admin"){
            e.preventDefault();
            // setLoggedIn(true);
            // redirect to /profile using Navigate 
            setUser("admin");
            setLoggedIn(true);
            navigate(`/`);
        } else {
            e.preventDefault();
            alert("Invalid username or password");
        }
        
    }
    const handleRegister = (e) => {
        navigate(`/register`);
    }




    var color_var = "#FFFFFF";
    return (
        <div className="loginpage1">
             <Navbar link="login" loggedIn={loggedIn}/> 
            <div id="split_left">
                <div className="left-login1">
                    <h1 className="logintitle1">Login</h1>
                    <input type="input" className="form__field1" placeholder="" name="username" id='username' required />
                    <label className="form__label1"><Icon icon="ant-design:user-outlined" color="#640064" />   User</label>

                    <input type="password" className="form__field2" placeholder="" name="password" id='password' required />
                    <label className="form__label2"><Icon icon="carbon:password" color="#640064" />   Pass</label>
                    <div className="label_btn1">
                        <div className="btn_login_div1" onClick={handleLogin}><div className= "btn_login" style={{color:color_var}}>Login</div></div>
                        <div className="btn_login_div1" onClick={handleRegister}><div className= "btn_login" style={{color:color_var}}>Register</div></div>
                    </div>
                </div>
            </div>
            
            <div id="split_right1">
                <div className="centered-login1">
                    <Icon icon="ion:car-sport-outline" color="#640064" width="260" />
                    <h1 className="buysell1">Buy and Sell Cars</h1>
                </div>
            </div>
        </div>
        

    )
}

export  default Login;