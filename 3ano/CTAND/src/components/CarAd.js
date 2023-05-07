import React from 'react'
import {useEffect, useCallback, useState} from 'react'
import './CarAd.css'
import { Icon } from '@iconify/react';
import {motion, AnimatePresence} from 'framer-motion'
import Navbar from './Navbar';
import Buttest from '../pages/Buttest.js';
import ButComp from '../pages/Butcomp.js';
import ReportAd from './ReportAd';
import { useNavigate } from 'react-router-dom';


function CarAd({closeAd, visible, opacity, transition, carObject, user}) {

    let navigate = useNavigate();

    const [test, setTest] = useState(false);
    const [buy , setBuy] = useState(false);
    const[reportAd, setReportAd] = useState(false);
    const[bgcolor, setBgcolor] = useState("#fffff");
    const [firstButtonContent, setFirstButtonContent] = useState("");
    const [secondButtonContent, setSecondButtonContent] = useState("");

    useEffect(() => {
        console.log("user:" + user)
        if (user === "user") {
            setFirstButtonContent("Test Drive");
            setSecondButtonContent("Buy");
            setBgcolor("#fffff");
        } else if (user === "admin") {
            // setFirstButtonContent("Delete seller account");
            setSecondButtonContent("Delete ad");
            setBgcolor("#FF5D5D");
        } else if (user === "agent") {
            setFirstButtonContent("Car sold");
            setSecondButtonContent("Genterate invoice");
            setBgcolor("#63FFBE");
        } else {
            setFirstButtonContent("Test Drive");
            setSecondButtonContent("Buy");
            setBgcolor("#fffff");
        }
    }  , [user]);


    const escFunction = useCallback((event) => {
        if (event.keyCode === 27) {
          closeAd(false);
          visible('visible');
          opacity('1');
          transition('visibility 0.3s linear,opacity 0.3s linear');
        }
      }, []);

    //onclick function to setTest to true
    const onClickTest = () => {
        if (user === "user" || user === "seller") {

            setTest(true);
        } else if (user === "agent"){
            console.log("car sold");
            //add to variable data the carObject.marca, carObject.modelo and carObject.imagem
            const data = new FormData();
            data.append("brand", carObject.marca);
            data.append("model", carObject.modelo);
            data.append("image", carObject.imagem);
            console.log(data)
            //send data to server 'http://localhost:5000/api/deletecar'
            fetch('http://localhost:5000/api/deletecar', {
                method: 'POST',
                body: data,
                mode: 'no-cors',
            }).then(res => {
                console.log(res);
                window.location.reload(false);
            })
        } else {
            navigate('/login');
        }
    }
    //onclick function to setBuy to true
    const onClickBuy = () => {
        console.log("clicked")
        if (user === "user" || user === "seller") {
            setBuy(true);
        } else if (user === "admin") {
            setReportAd(true);
        } else if (user === "agent") {
            alert("Invoice generated");
        }   else {
            navigate('/login');
        }
    }


    useEffect(() => {
    document.addEventListener("keydown", escFunction);

    return () => {
        document.removeEventListener("keydown", escFunction);
    };
    }, [escFunction]);

    return (
        <motion.div 
        animate={{x:0}}
        initial={{x:1000}} 
        exit={{ x:-2000}}
        transition={{ type: "spring", stiffness: 380, damping: 30}}
        
        className='CarAd'>

            {/* <Navbar link="buyacar" loggedIn= {loggedIn}/> */}

            <button className='backButton' onClick={() => {closeAd(false); visible('visible');opacity('1'); transition('visibility 0.3s linear,opacity 0.3s linear') }}>
                <Icon icon="akar-icons:arrow-left"/>
            </button>
            
            <div className='left-container'>
                <div className='overview'>
                    <img className="carAd-image" src={require('../images/'+carObject.imagem)}/>
                    <h1 className='car-name'>{carObject.marca + " " + carObject.modelo}</h1>
                </div>
                <div className='car-info'>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Kms:</em> {carObject.kms} km</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Price:</em> {carObject.preco} €</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Year:</em> {carObject.ano}</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Fuel:</em> Diesel (45L)</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Engine:</em> 1995 cm3</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Horsepower:</em> 150cv</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Consumption:</em> 5,9L/100km</p>
                </div>
                <div className='agent-info'>
                    <p><em style={{fontStyle:'normal', fontWeight:'600'}}>Email:</em> agent_email@gmail.com</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'600'}}>Phone:</em> 912345678</p>
                </div>
            </div>
            <div className='middle-container'>
                <div className='car-description'>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Advertiser:</em> Professional</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Accepts returns:</em> Yes</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Return value:</em> Same</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Possibility of financing:</em> Yes</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Segment:</em> City</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Transmition:</em> Automatic</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Doors:</em> 5</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Capacity:</em> 5 people</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Vehicle class:</em> Class 1</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Stand warranty:</em> 2 years</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Origin:</em> National</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Non-smoker:</em> Yes</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Revision book:</em> Included</p>
                </div>
            </div>
            <div className='right-container'>
                <div className='car-description'>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Observations:</em> I have this car, 
                    it’s very confotable and economic. I managed to average 6,1L/100km 
                    driving in town. Regarding costs, Audi is a bit expensive, and the 
                    inspection is about 300€. Once i had to replace a rim and because it was an original, 
                    I had to pay 500€. Overall, very happy with this car.</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Contact:</em> contact@email.com | 912345678</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Localization:</em></p>
                    <img className="stand-image" src={require('../images/stand_location.png')}/>
                </div>
            </div>
            
            {user !== "admin" && <div onClick={onClickTest} className='firstButton' style={{backgroundColor:bgcolor, color: user==="admin"? '#ffffff' : ''}} >{firstButtonContent}</div>}
            {test  && <Buttest setTest={setTest} user={user}/>}
            <div onClick={onClickBuy} className='secondButton' style={{backgroundColor:bgcolor, color: user==="admin"? '#ffffff' : ''}}>{secondButtonContent}</div>
            {buy && <ButComp setBuy={setBuy} user={user}/>}

            {reportAd && <ReportAd setReportAd={setReportAd} carObject= {carObject}/>}
            
        </motion.div>
    )
}   

export default CarAd