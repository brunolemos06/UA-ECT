// eslint-disable-next-line
import React, { useEffect, useState } from "react";
import CarDiv from "../layout/CarDiv";
import './Home.css';
import Cars from "../../database/cars.json"
import Reviews from "../../database/reviews.json"
import Navbar from "../layout/Navbar";
import CarAd from "../layout/CarAd";
import {motion, AnimatePresence} from 'framer-motion';
import Embed_reviews from "../layout/Embed_reviews";

function Home(props) {

    const [openAd, setOpenAd] = useState(false);

    const[activeTab, setActiveTab] = useState(0);
    const[noCars, setNoCars] = useState(false);
    const[noReviews, setNoReviews] = useState(false);


    const [visibility, setVisibility] = useState('visible');
    const [searchTerm, setSearchTerm] = useState("");
    const [carObject, setCarObject] = useState({});
    const [opacity, setOpacity] = useState('1');
    const [transition, setTransition] = useState('visibility 0.3s linear,opacity 0.3s linear');
    const numbers = ['heart','fav','heart'];
    // choose an random value from numbers array
    const randomNumberInRange = (min, max) => {
        // 👇️ get number between min (inclusive) and max (inclusive)
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    //Onclick open car ad 
    const divOnClick = (marca, modelo, year) => {
        setOpenAd(true);
        setVisibility('hidden');
        setOpacity('0');
        setTransition('none')
        let car = array.find(item => item.marca === marca && item.modelo === modelo && item.ano === year)
        setCarObject(car);
        console.log(marca)
    }
    //car Json into array
    var array = [];
    Object.keys(Cars).forEach(function (key) {
        array.push(Cars[key]);

    });

    //Review Json into array
    var rev_array = [];
    Object.keys(Reviews).forEach(function (key) {
        rev_array.push(Reviews[key]);

    });

    //Filter reviews based on input
    const listReviews = rev_array.filter((item) => {
        var search = searchTerm.toLowerCase().replace(/\s/g, '');
        var car1 = item.marca.toLowerCase()+item.modelo.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        var car2 = item.marca.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        var car3 = item.modelo.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        if(searchTerm === ""){
            return item
        } else if (car1.includes(search) || car2.includes(search) || car3.includes(search)){
            return item
        }
        else {
            return null
        }
    }).map((item,key) => 
    <div key={key} onClick={() => divOnClick(item.marca, item.modelo, item.ano)}> 
        <Embed_reviews icon={numbers[randomNumberInRange(0,2)]} title={item.autor +  ' - ' + item.marca + " " + item.modelo + '(' + item.ano + ')'} description={item.comentario} image={item.imagem}></Embed_reviews>
    </div>       
    );



    //Filter cars based on input
    const listCars = array.filter((item) => {
        var search = searchTerm.toLowerCase().replace(/\s/g, '');
        var car1 = item.marca.toLowerCase()+item.modelo.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        var car2 = item.marca.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        var car3 = item.modelo.toLowerCase()+item.ano.toLowerCase().replace(/\s/g, '');
        if(searchTerm === ""){
            return item
        } else if (car1.includes(search) || car2.includes(search) || car3.includes(search)) {
            return item
        }
        else {
            return null
        }
    }).map((item,key) => 
        <div className="car" onClick={() => divOnClick(item.marca, item.modelo, item.ano)} key={key}>
            <CarDiv image={item.imagem} trash={false} info= {<React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}</React.Fragment>}/>
        </div>
    );

    //If there are no cars in listCars, set noCars to true using setNoCars and useEffect
    useEffect(() => {
        if(listCars.length === 0){
            setNoCars(true);
        } else {
            setNoCars(false);
        }
    }
    , [listCars]);

    //If there are no reviews in listReviews, set noReviews to true using setNoReviews and useEffect
    useEffect(() => {
        if(listReviews.length === 0){
            setNoReviews(true);
        } else {
            setNoReviews(false);
        }
    }
    , [listReviews]);

    return (
        <div className="Home">
            {!openAd && <div className="tabs">
                <div className="activeCars" onClick={() => setActiveTab(0)} style={{textDecoration: activeTab === 0? 'underline': '', color:activeTab===0? '#4FBFB9': '#646464'}}>
                    Cars
                </div>
                <div className="activeReviews" onClick={() => setActiveTab(1)} style={{textDecoration: activeTab === 1? 'underline': '', color:activeTab===1? '#4FBFB9': '#646464'}}>
                    Reviews
                </div>
            </div>}
            
            <Navbar link="buyacar" loggedIn= {props.loggedIn} className='home-nav'/>

            {!openAd && <motion.div animate={{opacity : 1, y:0}} initial={{opacity:0, y:2}} exit={{opacity:0, y:10}} transition={{ duration:0.3}} className="divider"></motion.div>}

            {!openAd && <input  className="searchInput" type={'text'} placeholder={'Search...'} onChange={(event) => setSearchTerm(event.target.value)}/>}

            <AnimatePresence>
            {openAd && <motion.div><CarAd closeAd={setOpenAd} visible={setVisibility} opacity={setOpacity} transition={setTransition} carObject={carObject}/></motion.div>}
            </AnimatePresence>

            {activeTab===0 && <motion.div className="cars" style={{visibility:visibility, opacity:opacity, transition:transition}}>
                <AnimatePresence>
                {listCars}
                </AnimatePresence>
            </motion.div>}
            {noCars &&  activeTab===0 && 
            <div className="noCars">
                <img src={require('../../images/notFound.png')} alt="noCarsImg" className="noCarsImg"/>
                <p className="noCarsText">No cars found :(</p>
            </div>}

            {noReviews &&  activeTab===1 && 
            <div className="noCars">
                <img src={require('../../images/notFound.png')} alt="noCarsImg" className="noCarsImg"/>
                <p className="noCarsText">No reviews found :(</p>
            </div>}
            {activeTab===1 && !openAd && <motion.div className="Comments">
                <AnimatePresence>
                    {listReviews}
                </AnimatePresence>
            </motion.div>}
    
        </div>
    );
}

export default Home;