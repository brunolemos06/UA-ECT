import React from 'react'
import {useEffect, useCallback, useState} from 'react'
import './CarAd.css'
import { Icon } from '@iconify/react';
import {motion, AnimatePresence} from 'framer-motion'
import CarReview from './CarReview';
import Star from './Star';
import evaluation from '../../images/Rectangle_1.svg'

function CarAd({closeAd, visible, opacity, transition, carObject}) {
    
    const [random, setRandom] = useState(Math.floor(Math.random() * 5) + 1);
    const escFunction = useCallback((event) => {
        if (event.keyCode === 27) {
          closeAd(false);
          visible('visible');
          opacity('1');
          transition('visibility 0.3s linear,opacity 0.3s linear');
        }
      }, []);

    useEffect(() => {
        document.addEventListener("keydown", escFunction);

        return () => {
            document.removeEventListener("keydown", escFunction);
        };
    }, [escFunction]);

    const[openReview, setOpenReview] = useState(false);

    const reviewButton = () => {
        console.log("reviewButton");
        setOpenReview(true);
    }


    return (
        <motion.div 
        animate={{x:0}}
        initial={{x:1000}} 
        exit={{ x:-2000}}
        transition={{ type: "spring", stiffness: 380, damping: 30}}
        
        className='CarAd-bg'>
            <button className='backButton' onClick={() => {closeAd(false); visible('visible');opacity('1'); transition('visibility 0.3s linear,opacity 0.3s linear') }}>
                <Icon icon="bi:arrow-left"/>
            </button>
            <AnimatePresence>
                {openReview && <motion.div className='reviewPopup'><CarReview carobject={carObject} setopenreview={setOpenReview}/></motion.div>}
            </AnimatePresence>

            <div className='left-container'>
                <div className='overview'>
                    <img className="carAd-image" src={require('../../images/'+carObject.imagem)}/>
                    <img className="carAd-image" src={require('../../images/'+carObject.imagem2)}/>
                </div>
                <div className='car-info'>
                    
                </div>
            </div>
            <div className='middle-container'>
                <div className='car-description'>
                    <h2 className='car-name'>{carObject.marca + " " + carObject.modelo}</h2>
                    <Star stars={random}/>
                    {/* <img className='siteevaluation' src={evaluation}/> */}
                    {/* <h1 className="Ourevaluation">Our evaluation</h1>
                    <Icon className='arrowevaluation' icon="bxs:down-arrow" color="black"/> */}
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Kms:</em> {carObject.kms} km</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Price:</em> {carObject.preco} €</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Year:</em> {carObject.ano}</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Fuel:</em> Diesel (45L)</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Engine:</em> 1995 cm3</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Horsepower:</em> 120cv</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Consumption:</em> 5,9L/100km</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Accepts returns:</em> Yes</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Segment:</em> City</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Transmition:</em> Automatic</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Capacity:</em> 5 people</p>
                    <p><em style={{fontStyle:'normal', fontWeight:'bold'}}>Stand warranty:</em> 2 years</p>
                </div>
                <button className='reviewsButton' onClick={reviewButton}>Reviews<Icon icon="entypo:popup" className='popupBtn'/></button>
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
                    <img className="stand-image" src={require('../../images/stand_location.png')}/>
                </div>
            </div>
            
        </motion.div>
    )
}

export default CarAd