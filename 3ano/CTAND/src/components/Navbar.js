import {Link} from 'react-router-dom';
import React, { useEffect } from 'react';

import  './Navbar.css';
import { Icon } from '@iconify/react';

function Navbar(props){

    const [logged, setLogged] = React.useState('/login');

    useEffect(() => {
        if(props.loggedIn){
            setLogged('/profile');
        } else {
            setLogged('/login');
        }
    }, [props.loggedIn]);


    var buyShadow = "#0px 0px 0px #FFFFFF";
    var sellShadow = "#0px 0px 0px #FFFFFF";
    var profileShadow = "#0px 0px 0px #FFFFFF";

    if (props.link === "buyacar"){
        buyShadow = "0px 0px 5px #FFFFFF, 0px 0px 10px #FFFFFF, 0px 0px 15px #FFFFFF, 0px 0px 20px #FFFFFF";
    } else if (props.link === "sellcar"){
        sellShadow = "0px 0px 5px #FFFFFF, 0px 0px 10px #FFFFFF, 0px 0px 15px #FFFFFF, 0px 0px 20px #FFFFFF";
    } else if (props.link === "login"){
        profileShadow = "0px 0px 5px #FFFFFF, 0px 0px 10px #FFFFFF, 0px 0px 15px #FFFFFF, 0px 0px 20px #FFFFFF";
    } else if (props.link === "profile"){
        profileShadow = "0px 0px 5px #FFFFFF, 0px 0px 10px #FFFFFF, 0px 0px 15px #FFFFFF, 0px 0px 20px #FFFFFF";
    }


    return(
        <div className='navbar-div'>
                <div className='navbar'>
                    <Link to='/' className='ctand'> CTand</Link>
                    <nav className='nav-links'>
                        <Link to='/' className='buyacar' style={{textShadow:buyShadow}}> Buy a car</Link>
                        <Link to='/Sellcar' className='sellacar' style={{textShadow:sellShadow}}> Sell a car</Link>
                        <Link to={logged} className='icon' style={{textShadow:profileShadow}}> Profile</Link>
                        {/* <Link to={logged} className='icon'> 
                            <Icon icon="akar-icons:person" hFlip={true} style={{filter:'drop-shadow('+profileShadow+')'}}/>
                        </Link> */}
                    </nav>
                </div>

        </div>
    )
}

export default Navbar;