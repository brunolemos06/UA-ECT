import {Link} from 'react-router-dom';
import Container from './Container';
import React, { useEffect } from 'react';

import  './Navbar.css';
import { Icon } from '@iconify/react';
import "@fontsource/roboto-mono";

function Navbar(props){

    console.log(props);

    const [logged, setLogged] = React.useState('/login');

    useEffect(() => {
        if(props.loggedIn){
            setLogged('/profile');
        } else {
            setLogged('/login');
        }
    }, [props.loggedIn]);


    var buyColor = "#FFFFFF";
    var sellColor = "#FFFFFF";
    var reviewColor = "#FFFFFF";
    var profileColor = "#FFFFFF";

    if (props.link === "buyacar"){
        buyColor = "#646464";
    } else if (props.link === "sellacar"){
        sellColor = "#646464";
    } else if (props.link === "makeareview"){
        reviewColor = "#646464";
    } else if (props.link === "profile"){
        profileColor = "#646464";
    } else if (props.link === "login"){
        profileColor = "#646464";
    }


    return(
        <nav>
                <Container className='navbar'>
                    <Link to='/' className='home'> StandForU</Link>
                    <nav className='nav-links'>
                        <Link to='/' className='buyacar' style={{color:buyColor}}> Buy a car</Link>
                        <Link to='/sell-car' className='sellacar' style={{color:sellColor}}> Sell a car</Link>
                        <Link to='/make-review' className='makeareview' style={{color:reviewColor}}> Make a review</Link>

                        <Link to={logged} className='icon' style={{color:'#646464'}}> 
                            <Icon icon="akar-icons:person" hFlip={true} style={{color:profileColor}}/>
                        </Link>
                    </nav>
                </Container>

        </nav>
    )
}

export default Navbar;