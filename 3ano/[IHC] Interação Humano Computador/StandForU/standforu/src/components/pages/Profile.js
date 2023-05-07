import React, { useEffect, useState } from "react";
import Navbar from "../layout/Navbar"
import'./Profile.css'
import car1 from '../../images/jeep-wrangler-2006.jpg'
import car2 from '../../images/corolla.jpg'
import Cars from "../../database/cars1.json";
import CarDiv from "../layout/CarDiv.js";
import {motion, AnimatePresence} from 'framer-motion';
import fotoperfil from '../../images/fotoperfil.png'  
import { useNavigate } from "react-router-dom";  
import { Icon } from '@iconify/react';
import Embed_reviews from   '../layout/Embed_reviews.js'
import Comments from '../../database/comments.json'
import {ToastContainer,toast,Zoom,Bounce} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import axios from "axios";


function Profile (props){

    let navigate = useNavigate();
    const [apagar,setapagar] = React.useState("visible");
    const [apagar2,setapagar2] = React.useState("visible");
    var array = [];

    const handleLogout = (e) => {
        e.preventDefault();
        props.setLoggedIn(false);
        // redirect to /profile using Navigate 
        navigate(`/`);
    }
    //funcao para colocar apagar a true
    const handleApagar1 = () => {
        setapagar("hidden");
    }
    const handleApagar2 = () => {
        setapagar2("hidden");
    }
    //Imprimir na console o valor de apagar
    console.log(apagar);

    
    Object.keys(Comments).forEach(function (key) {
        array.push(Comments[key]);
    });


      const listComments = array.map((item,key) => 
          <div key={key}>
              <Embed_reviews icon ={'trash'} title={item.title} description ={item.description} image={item.imagem} margin={true}/>
          </div>
      );

    const [openAd, setOpenAd] = useState(false);
    const [carObject, setCarObject] = useState({});
    //Animation related states
    const [visibility, setVisibility] = useState('visible');
    const [opacity, setOpacity] = useState('1');
    const [transition, setTransition] = useState('visibility 0.3s linear,opacity 0.3s linear');

    const divOnClick = (marca, modelo, year) => {
        setOpenAd(true);
        setVisibility('hidden');
        setOpacity('0');
        setTransition('none')
        let car = array.find(item => item.marca === marca && item.modelo === modelo && item.ano === year)
        setCarObject(car);
    }

    var array = [];
    Object.keys(Cars).forEach(function (key) {
        array.push(Cars[key]);
    });

    var filteredCars = array;
    const listCars = filteredCars.map((item, key) =>
        <div className="car"  key={key}>
           <CarDiv image={item.imagem} profile={true} info= {<React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}</React.Fragment>}/>
        </div>
    );

    
    return (
        <div className="profilepage">
            {/* <ToastContainer/> */}
            <Navbar link="profile" loggedIn={props.loggedIn}/>
            <div className="profile">
                <img src={fotoperfil} className="fotoperfil"/>
                <h2 className="dados1">João Viegas</h2>
                <h2 className="dados2">Joined 20/03/2021</h2>
                <h2 className="dados3">Jonha@gmail.com</h2>
                <h2 className="dados4">235649486</h2>
                <h2 className="dados5">I love sports cars, personally have a Audi A1 and a 1998 nissan GTR</h2>

            </div>
            <div className="mycars">
                <h1 className="myselcars">My selling cars</h1>
                <motion.div className="carprof" style={{visibility:visibility, opacity:opacity, transition:transition}}>
                    <AnimatePresence>
                    {listCars}
                    </AnimatePresence>
                </motion.div>
            </div>
            <div className="myreviews">
                    <h1 className="myrev">My Reviews</h1>
                    <div className="CommentsProfile">
                        {listComments}
                    </div>
            </div> 
            <button className="logout-button" onClick={handleLogout}>Logout</button>
        </div>
        

    )
}

export  default Profile;