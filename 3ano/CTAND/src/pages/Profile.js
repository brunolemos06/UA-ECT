import React, { useEffect, useState } from "react";
import Navbar from "../components/Navbar";
import'./Profile.css'
import CarDiv from "../components/CarDiv";
import seller_img from '../images/seller.png'  
import buyer_img from '../images/buyer.png'
import moderator_img from '../images/moderator.png'
import { useNavigate } from "react-router-dom";  
import {motion, AnimatePresence} from 'framer-motion';
import CarAd from "../components/CarAd";


function Profile (props){

    //run this code when the component is mounted
    useEffect(() => {
        console.log(props.user);
        if(props.user === ""){
            navigate("/login");
        } else if (props.user === "agent"){
            navigate("/agent");
        }
    }
    , [props.user]);

    const [cars, setCars] = useState([]);
    useEffect(() => {
        fetch("http://localhost:5000/api/profile_cars")
        .then(res => res.json())
        .then(data => setCars(data))
        .catch(err => console.log(err));
    }, []);

    const [username, setUsername] = useState("");
    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState("");
    const [details, setDetails ] = useState("");
    const [date, setDate] = useState("");
    const [image, setImage] = useState("");

    //run this code when the component is mounted
    useEffect(() => {
        if (props.user === "user"){
            setUsername("João Lemos");
            setEmail("joaolemos@email.com")
            setPhone("234123456")
            setDetails("Im a musician and I love to play guitar")
            setDate("01/01/2020")
            setImage(buyer_img)
        } else if (props.user === "seller"){
            setUsername("Bruno Amaral");
            setEmail("brunoamaral@email.com")
            setPhone("234123456")
            setDetails("I have a stand that sells cars since 1983")
            setDate("01/01/2021")
            setImage(seller_img)
        } else if (props.user === "admin"){
            setUsername("Antónia Rocha");
            setEmail("antoniarocha@ctand.com")
            setPhone("234123456")
            setDetails("Moderator")
            setDate("28/09/2018")
            setImage(moderator_img)
        } else {
            navigate("/login");
        }
    }
    , [props.user]);


    let navigate = useNavigate();
    var array = [];

    const handleLogout = (e) => {
        e.preventDefault();
        props.setLoggedIn(false);
        props.setUser("")
        // redirect to /profile using Navigate 
        navigate(`/`);
    }

    //Imprimir na console o valor de apagar
    const [openAd, setOpenAd] = useState(false);
    const [carObject, setCarObject] = useState({});
    //Animation related states
    const [visibility, setVisibility] = useState('visible');
    const [opacity, setOpacity] = useState('1');
    const [transition, setTransition] = useState('visibility 0.3s linear,opacity 0.3s linear');

    const divOnClick = (marca, modelo, year) => {
        setOpenAd(true);
        let car = array.find(item => item.marca === marca && item.modelo === modelo && item.ano === year)
        setCarObject(car);
        console.log(car);
    }

    var array = [];
    Object.keys(cars).forEach(function (key) {
        array.push(cars[key]);
    });

    var filteredCars = array;
    const listCars = filteredCars.map((item, key) =>
        <div className="car" onClick={() => divOnClick(item.marca, item.modelo, item.ano)} key={key}>
           <CarDiv trash={false} image={item.imagem} info= {<React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}</React.Fragment>}/>
        </div>
    );

    
    
    

    
    return (
        <div className="profilepage">
            <Navbar link="profile" loggedIn={props.loggedIn}/>
            {!openAd && <div className="profile" style={{left : props.user !=="admin"? '20vw' : '38vw'}}>
                <img src={image} className="fotoperfil"/>
                <h2 className="dados1">{username}</h2>
                <h2 className="dados2">Joined {date}</h2>
                <h2 className="dados3">{email}</h2>
                <h2 className="dados4">{phone}</h2>
                <h2 className="dados5">{details}</h2>

            </div>}

            <AnimatePresence>
                {openAd && <motion.div><CarAd closeAd={setOpenAd} carObject={carObject} loggedIn={props.loggedIn}/></motion.div>}
            </AnimatePresence>

            {props.user !=="admin" && !openAd && <div className="mycars">
                <h1 className="myselcars">My selling cars</h1>
                <motion.div className="carprof" style={{visibility:visibility, opacity:opacity, transition:transition}}>
                    {props.user==="seller" && <AnimatePresence>
                    {listCars}
                    </AnimatePresence>}
                </motion.div>
                {props.user !== "seller" && <h1 className="nocars">You don't have any cars for sale!</h1>}
            </div>}
            {!openAd && <button className="logout-button" onClick={handleLogout} style={{left : props.user !=="admin"? '35.5vw' : '53.5vw'}} >Logout</button>}
        </div>
        

    )
}

export  default Profile;