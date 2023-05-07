import React from "react";
import {useEffect, useCallback, useState} from 'react'
import Navbar from "../layout/Navbar"
import'./login.css'
import {Link, useNavigate} from 'react-router-dom';
import { Icon } from '@iconify/react';
import {ToastContainer,toast,Zoom,Bounce} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';



function Login ({loggedIn, setLoggedIn}){
    let navigate = useNavigate();
    let enter = 13;
    const enterFunction = useCallback((event) => {
        if (event.keyCode === enter) {
            if(document.getElementById('username').value === "admin" && document.getElementById('password').value === "admin"){
                event.preventDefault();
                setLoggedIn(true);
                // redirect to /profile using Navigate 
                navigate(`/profile`);
            } else {
                toast.error("Wrong username or password!");
            }
        }
      }, []);
    
    useEffect(() => {
    document.addEventListener("keydown", enterFunction);

    return () => {
        document.removeEventListener("keydown", enterFunction);
    };
    }, [enterFunction]);
    
    const handleLogin = (e) => {

        if(document.getElementById('username').value === "admin" && document.getElementById('password').value === "admin"){
            e.preventDefault();
            setLoggedIn(true);
            // redirect to /profile using Navigate 
            navigate(`/profile`);
        } else {
            toast.error("Wrong username or password!");
        }
    }
    const handleRegister = (e) => {
        navigate(`/register`);
    }

    var color_var = "#FFFFFF";
    return (
        <div className="loginpage">
            <Navbar link="login" loggedIn={loggedIn}/>
            <div id="split_left">
                <div className="left-login">
                    <h1 className="logintitle">Login</h1>
                    <input type="input" className="form__field1" placeholder="" name="username" id='username' required />
                    <label className="form__label1"><Icon icon="ant-design:user-outlined" color="#4fbfb9" />   User</label>

                    <input type="password" className="form__field2" placeholder="" name="password" id='password' required />
                    <label className="form__label2"><Icon icon="carbon:password" color="#4fbfb9" />   Pass</label>
                    <div className="label_btn">
                        <div className="btn_login_div" onClick={handleLogin}><div className= "btn_login" style={{color:color_var}}>login</div></div>
                        <div className="btn_login_div" onClick={handleRegister}><div className= "btn_login" style={{color:color_var}}>Register</div></div>
                    </div>
                </div>
            </div>
            
            <div id="split_right">
                <div className="centered-login">
                    <Icon icon="ion:car-sport-outline" color="#4fbfb9" width="260" />
                    <h1 className="buysell">Buy, Sell and Review Cars</h1>
                </div>
            </div>
        </div>
        

    )
}

export  default Login;