// eslint-disable-next-line
import React, {useState, useEffect} from "react";
import CarDiv from "../components/CarDiv";
import './Home.css';
import './AgentPage.css'
import {Link} from 'react-router-dom';
import CarAd from "../components/CarAd";
import {motion, AnimatePresence} from 'framer-motion';
import { useNavigate } from "react-router-dom";

function AgentPage({loggedIn, setLoggedIn, setUser,user}) {

    let navigate = useNavigate();

    const [cars, setCars] = useState([]);
    useEffect(() => {
        console.log(user);
        fetch("http://localhost:5000/api/agent_cars")
        .then(res => res.json())
        .then(data => setCars(data))
        .catch(err => console.log(err));
    }, []);

    //Car and ad related states
    const [openAd, setOpenAd] = useState(false);
    const [carObject, setCarObject] = useState({});

    //Animation related states
    const [visibility, setVisibility] = useState('visible');
    const [opacity, setOpacity] = useState('1');
    const [transition, setTransition] = useState('visibility 0.3s linear,opacity 0.3s linear');

    //Filter related states
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedYear, setSelectedYear] = useState("Year");
    const [selectedPrice, setSelectedPrice] = useState([0,10000000]);
    const [selectedKms, setSelectedKms] = useState([0,10000000]);


    //Onclick open car ad 
    const divOnClick = (marca, modelo, year) => {
        setOpenAd(true);
        setVisibility('hidden');
        setOpacity('0');
        setTransition('none')
        let car = array.find(item => item.marca === marca && item.modelo === modelo && item.ano === year)
        setCarObject(car);
    }
    const logout = () => {
      // implement log out function plssss
      console.log("logout");
      setUser("");
      setLoggedIn(false);
      navigate('/');
    }

    var array = [];
    Object.keys(cars).forEach(function (key) {
        array.push(cars[key]);
    });

    let filters = [searchTerm, selectedYear, selectedPrice, selectedKms];
    var filteredCars = array;
    
    //Cycle through filters and filter cars
    for (let i = 0; i < filters.length; i++) {
        if (i === 0 && filters[i] !== "") {
            filteredCars = filteredCars.filter(car => (car.marca.toLowerCase()+ ' ' + car.modelo.toLowerCase()).includes(filters[i].toLowerCase()));
        } else if (i === 1 && filters[i] !== "Year") {
            filteredCars = filteredCars.filter(item => item.ano === filters[i]);
        } else if (i === 2 && filters[i][0] !== -1 && filters[i][1] !== -1) {
            filteredCars = filteredCars.filter(item => item.preco >= filters[i][0] && item.preco <= filters[i][1]);
        } else if (i === 3 && filters[i][0] !== -1 && filters[i][1] !== -1) {
            filteredCars = filteredCars.filter(item => item.kms >= filters[i][0] && item.kms <= filters[i][1]);
        }
    }

    const listCars = filteredCars.map((item, key) =>
        <div className="car" onClick={() => divOnClick(item.marca, item.modelo, item.ano)} key={key}>
            <CarDiv image={item.imagem} info= {
                <React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}
                </React.Fragment>}
            />
        </div>
    );
    
    return (
        <div className="Home">
            <Link to='/agent' className='ctand' style={{width:'fit-content'}}>CTand - Agent</Link>
            {!openAd && <div className="assigned-ads">
                Assigned ads
            </div>}

            <div className="Home-content">
                {!openAd &&  <input  className="searchInput" type={'text'} placeholder={'Search...'} onChange={(event) => setSearchTerm(event.target.value)}/>}
                

                <AnimatePresence>
                {openAd && <motion.div><CarAd user={user} closeAd={setOpenAd} visible={setVisibility} opacity={setOpacity} transition={setTransition} carObject={carObject} loggedIn={loggedIn}/></motion.div>}
                </AnimatePresence>

                {!openAd && <motion.div animate={{opacity : 1, y:0}} initial={{opacity:0, y:2}} exit={{opacity:0, y:10}} transition={{ duration:0.3}} className="divider"></motion.div>}

                <motion.div className="cars" style={{visibility:visibility, opacity:opacity, transition:transition}}>
                    <AnimatePresence>
                    {listCars}
                    </AnimatePresence>
                </motion.div>
            </div>
            <div  onClick={logout} className='btn'>
                <h1 className='text'>Logout</h1>
            </div>
        </div>
    );
}

export default AgentPage;