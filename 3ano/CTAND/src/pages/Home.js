// eslint-disable-next-line
import React, { useEffect, useState } from "react";
import CarDiv from "../components/CarDiv";
import './Home.css';
import Navbar from "../components/Navbar";
import CarAd from "../components/CarAd";
import {motion, AnimatePresence} from 'framer-motion';
import Select from 'react-select';
import { useNavigate } from "react-router-dom";

function Home(props) {

    let navigate = useNavigate();
    

    //code to fetch the cars from localhost:5000/api/main_cars and store them in the state of cars
    const [cars, setCars] = useState([]);
    useEffect(() => {
        fetch("http://localhost:5000/api/main_cars")
        .then(res => res.json())
        .then(data => setCars(data))
        .catch(err => console.log(err));
    }, []);

    //run this code when the component is mounted
    useEffect(() => {
        if (props.user === "agent"){
            navigate("/agent");
        }
        console.log("home: " + props.user)
    }
    , [props.user]);

    const years = [
        { label: 'Ano', value: 'Year' },
        { label: '2022', value: '2022' },
        { label: '2021', value: '2021' },
        { label: '2020', value: '2020' },
        { label: '2019', value: '2019' },
        { label: '2018', value: '2018' },
        { label: '2017', value: '2017' },
        { label: '2016', value: '2016' },
        { label: '2015', value: '2015' },
        { label: '2014', value: '2014' },
        { label: '2013', value: '2013' },
        { label: '2012', value: '2012' },
        { label: '2011', value: '2011' },
        { label: '2010', value: '2010' },
        { label: '2009', value: '2009' },
        { label: '2008', value: '2008' },
        { label: '2007', value: '2007' },
        { label: '2006', value: '2006' },
        { label: '2005', value: '2005' },
        { label: '2004', value: '2004' },
        { label: '2003', value: '2003' },
        { label: '2002', value: '2002' },
        { label: '2001', value: '2001' },
        { label: '2000', value: '2000' },
        { label: '1999', value: '1999' },
        { label: '1998', value: '1998' },
        { label: '1997', value: '1997' },
        { label: '1996', value: '1996' },
        { label: '1995', value: '1995' },

      ];

    const prices = [
        { label: 'Preço', value: [-1, -1] },
        { label: '< 5000€', value: [0, 5000] },
        { label: '5000-10000€', value: [5000, 10000] },
        { label: '10000-15000€', value: [10000, 15000] },
        { label: '15000-20000€', value: [15000, 20000] },
        { label: '20000-25000€',  value: [20000, 25000] },
        { label: '25000-30000€',  value: [25000, 30000] },
        { label: '30000-40000€', value: [30000, 40000] },
        { label: '40000-50000€', value: [40000, 50000] },
        { label: '50000-75000€', value: [50000, 75000] },
        { label: '75000-100000€', value: [75000, 100000] },
        { label: '100000-200000€', value: [100000, 200000] },
        { label: '> 200000€', value: [200000, 10000000] },
    ];

    const kms = [
        { label: 'Kms', value: [-1, -1] },
        { label: '< 5000km', value: [0, 5000] },
        { label: '5000-10000km', value: [5000, 10000] },
        { label: '10000-20000km', value: [10000, 20000] },
        { label: '20000-35000km', value: [20000, 35000] },
        { label: '35000-50000km', value: [35000, 50000] },
        { label: '50000-75000km', value: [50000, 75000] },
        { label: '75000-100000km', value: [75000, 100000] },
        { label: '100000-125000km',     value: [100000, 125000] },
        { label: '125000-150000km',    value: [125000, 150000] },
        { label: '150000-200000km',   value: [150000, 200000] },
        { label: '200000-250000km',  value: [200000, 250000] },
        { label: '250000-300000km', value: [250000, 300000] },
        { label: '300000-350000km', value: [300000, 350000] },
        { label: '350000-400000km', value: [350000, 400000] },
        { label: '> 400000km', value: [400000, 10000000] } ,
    ];

    const customStylesYear = {
        menu: (provided) => ({
            ...provided,
            borderRadius: '10px',
            width: 130,
            justifyContent: 'center',
            alignItems: 'center',
            

        }),
        option: (provided, state) => ({
            ...provided,
            width: 115,
            marginLeft: 5,
            justifyContent: 'center',
            alignItems: 'center',
            color: state.isSelected ? 'white' : '#640064',
            backgroundColor: state.isSelected ? '#640064' : 'transparent',
            cursor: 'pointer',
            borderRadius: 10,
            "&:hover": {
                backgroundColor: '#8a578a',
                color: 'white',
            },
        }),
        control: () => ({
            width: 130,
            height: 48,
            borderRadius: 10,
            backgroundColor: '#f6f6f6',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            boxShadow: '4px 4px 8px rgba(0, 0, 0, 0.211)',
            placeholder: 'Year',
            

        }),
        singleValue: (provided, state) => {
            const opacity = state.isDisabled ? 0.5 : 1;
            const transition = 'opacity 300ms';
            
            return { ...provided, opacity, transition };
        }
    }

    const customStylesPrice = {
        menu: (provided) => ({
            ...provided,
            borderRadius: '10px',
            width: 190,
            justifyContent: 'center',
            alignItems: 'center',
            

        }),
        option: (provided, state) => ({
            ...provided,
            width: 175,
            marginLeft: 5,
            justifyContent: 'center',
            alignItems: 'center',
            color: state.isSelected ? 'white' : '#640064',
            backgroundColor: state.isSelected ? '#640064' : 'transparent',
            cursor: 'pointer',
            borderRadius: 10,
            "&:hover": {
                backgroundColor: '#8a578a',
                color: 'white',
            },
        }),
        control: () => ({
            width: 190,
            height: 48,
            borderRadius: 10,
            backgroundColor: '#f6f6f6',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            boxShadow: '4px 4px 8px rgba(0, 0, 0, 0.211)',
            placeholder: 'Year',
            

        }),
        singleValue: (provided, state) => {
            const opacity = state.isDisabled ? 0.5 : 1;
            const transition = 'opacity 300ms';
            
            return { ...provided, opacity, transition };
        }
    }

    const customStylesKms = {
        menu: (provided) => ({
            ...provided,
            borderRadius: '10px',
            width: 220,
            justifyContent: 'center',
            alignItems: 'center',
            

        }),
        option: (provided, state) => ({
            ...provided,
            width: 205,
            marginLeft: 5,
            justifyContent: 'center',
            alignItems: 'center',
            color: state.isSelected ? 'white' : '#640064',
            backgroundColor: state.isSelected ? '#640064' : 'transparent',
            cursor: 'pointer',
            borderRadius: 10,
            "&:hover": {
                backgroundColor: '#8a578a',
                color: 'white',
            },
        }),
        control: () => ({
            width: 220,
            height: 48,
            borderRadius: 10,
            backgroundColor: '#f6f6f6',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            boxShadow: '4px 4px 8px rgba(0, 0, 0, 0.211)',
            placeholder: 'Year',
            

        }),
        singleValue: (provided, state) => {
            const opacity = state.isDisabled ? 0.5 : 1;
            const transition = 'opacity 300ms';
            
            return { ...provided, opacity, transition };
        }
    }

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


    var array = [];
    Object.keys(cars).forEach(function (key) {
        array.push(cars[key]);
    });

    let filters = [searchTerm, selectedYear, selectedPrice, selectedKms];
    var filteredCars = array;
    
    //Cycle through filters and filter cars
    for (let i = 0; i < filters.length; i++) {
        if (i === 0 && filters[i] !== "") {
            filteredCars = filteredCars.filter(car => (car.marca.toLowerCase()+' '+car.modelo.toLowerCase()).includes(filters[i].toLowerCase()));
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
           <CarDiv trash={false} image={item.imagem} info= {<React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}</React.Fragment>}/>
        </div>
    );

    //useEffect to detect change in closeAd state
    
    

    //Filter cars based on input
    // const listCars = array.filter((item) => {
    //     var search = searchTerm.toLowerCase().replace(/\s/g, '');
    //     var car1 = item.marca.toLowerCase()+item.modelo.toLowerCase();
    //     if(searchTerm !== "" && selectedYear !== "Year"){
    //         return (car1.includes(search) && item.ano === selectedYear) ? item : null;
    //     } else if (selectedYear !== "Year") {
    //         return (item.ano === selectedYear) ? item : null;
    //     } else if (searchTerm !== "") {
    //         return (car1.includes(search)) ? item : null;
    //     }
    //     else {
    //         return item;
    //     }
    // }).map((item,key) => 
    //     <div className="car" onClick={() => divOnClick(item.marca, item.modelo, item.ano)} key={key}>
    //         <CarDiv image={item.imagem} info= {<React.Fragment> {item.marca + " " + item.modelo} <br/> {item.ano} <br/> {item.kms + " km"} <br/> {item.preco + " €"}</React.Fragment>}/>
    //     </div>
    // );



    return (
        <div className="Home">
            <Navbar link="buyacar" loggedIn= {props.loggedIn}/> 
            <div className="Home-content">
                {!openAd &&  <input  className="searchInput" type={'text'} placeholder={'Search...'} onChange={(event) => setSearchTerm(event.target.value)}/>}
                
                {!openAd && <div className="selects">
                    <Select className="selectYear"
                    styles={customStylesYear}
                    options={years}
                    placeholder={'Year'}
                    onChange={opt => setSelectedYear(opt.value)}
                    />

                    <Select className="selectPrice"
                    styles={customStylesPrice}
                    options={prices}
                    placeholder={'Price'}
                    onChange={opt => setSelectedPrice(opt.value)}
                    />
                    <Select className="selectKms"
                    styles={customStylesKms}
                    options={kms}
                    placeholder={'Kms'}
                    onChange={opt => setSelectedKms(opt.value)}
                    />
                </div>}

                <AnimatePresence>
                {openAd && <motion.div><CarAd  user={props.user} closeAd={setOpenAd} visible={setVisibility} opacity={setOpacity} transition={setTransition} carObject={carObject} loggedIn={props.loggedIn}/></motion.div>}
                </AnimatePresence>

                {!openAd && <motion.div animate={{opacity : 1, y:0}} initial={{opacity:0, y:2}} exit={{opacity:0, y:10}} transition={{ duration:0.3}} className="divider"></motion.div>}

                <motion.div className="cars" style={{visibility:visibility, opacity:opacity, transition:transition}}>
                    <AnimatePresence>
                    {listCars}
                    </AnimatePresence>
                </motion.div>
            </div>
        </div>
    );
}

export default Home;