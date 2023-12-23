import React, { useState, useEffect } from 'react';
import './App.css';
import { Icon } from '@iconify/react';




function App() {

  const rows = 15;
  const cols = 30;
  const side = 50;

  const [connection, setConnection] = useState(false);
  const [squares, setSquares] = useState([]);
  const [boats, setBoats] = useState([]);
  const [getsensor, setGetsensor] = useState([]);
  const [rsu] = useState([
    { id: 0, position : [0,0] },
  ]);
  const [sensor, setSensor] = useState([
  ]);
  const [perimeter, setPerimeter] = useState([
    [2, 1, 1, 1],
    ['', 2, 1, 1],
    ['', '', 2, 1],
    ['', '', '', 2],
  ]);
  const [pickedSensor, setPickedSensor] = useState({});

  const[info, setInfo] = useState(
    {
      // "[11.0, 8.0]": { "plankton_levels": 0.48793308321408124 },
      // "[15.0, 6.0]": { "conductivity": 0.8004786827577958, "temperature": 0.8259230769573657, "depth": 0.6087486422380269 },
      // "[22.0, 3.0]": { "conductivity": 0.2911129244117344, "temperature": 0.39933072368555766, "depth": 0.42501355818209596 },
      // "[21.0, 11.0]": { "plankton_levels": 0.002043041244941035 },
      // "[4.0, 7.0]": { "conductivity": 0.4527549518198394, "temperature": 0.5743784373716827, "depth": 0.8133351669651468 },
      // "[4.0, 14.0]": { "oxygen": 0.2210360639029606, "carbon_dioxide": 0.7383645104672287, "methane": 0.9422249151750264 },
      // "[26.0, 10.0]": { "conductivity": 0.17577212192714986, "temperature": 0.26303862681891543, "depth": 0.9965909020969383 },
      // "[1.0, 12.0]": { "oxygen": 0.7439012210958476, "carbon_dioxide": 0.702309309129735, "methane": 0.7978803222609001 }
    });

  
  const loadstaticInfo = async () => {
    try{
      const response = await fetch('http://localhost:8080/sensor');
      const data = await response.json();
      setConnection(true);
      setSensor([]); // Remove old sensor from state
      const newSensor = [];
      for (const id in data) {
        const position = data[id];
        newSensor.push({ id: Number(id), position });
      }
      setConnection(true);
      setSensor(newSensor);
    }catch(error){
      console.log("No connection to the API");
      setConnection(false);
    }
  };

  const getinfo = async () => {
    try{
      const response = await fetch('http://localhost:8080/info');
      const data = await response.json();
      setConnection(true);
      setInfo(data);
    }catch(error){
      console.log("No connection to the API");
      setConnection(false);
    }
  };

  // loadstaticInfo();

  const createGrid = () => {
    const grid = [];
    // remove all divs that contains named :
    // square rsu
    // square sensor
    // square boat
    // square
  
    // create the grid
    for (let i = 0; i < rows; i++) {
      for (let j = 0; j < cols; j++) {
          
        // display sensor in the grid
        sensor.forEach((sensor) => {
          if (sensor.position[0] === j && sensor.position[1] === i) {
            const sensorSquare = (
              // put an icon in the square
              <div
                className="square sensor"
                style={{ top: i * side, left: j * side }}
              >
                {/* check if sensorid is in array of getsensor */}
                {getsensor.includes(sensor.id) ? (
                  <Icon icon="icon-park-solid:float" color="green" width="50" height="50" />
                ) : (
                  <Icon icon="icon-park-solid:float" color="red" width="50" height="50" />
                )}
                <div className='namediv'><p className='name'>{sensor.id+1}</p></div>
              </div>
            );
            grid.push(sensorSquare);
          }
        });

        boats.forEach((boat) => {
          if (boat.position[0] === j && boat.position[1] === i) {
            //check if the boat is in in the same position of the sensor
            sensor.forEach((sensor) => {
              if (sensor.position[0] === j && sensor.position[1] === i) {
                getsensor.push(sensor.id);
              }
            });
            const boatSquare = (
              <div className="square boat" style={{ top: i * side, left: j * side }}>
                <Icon icon="noto:sailboat" width="50" height="50" />
                <div className="namediv">
                  <p className="name">{boat.id}</p>
                </div>
                {/* Add circle with radius 5 */}
                <svg
                  className="circle"
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%, -50%)",
                  }}
                  height="700"
                  width="700"
                >
                  <circle
                    cx="350"
                    cy="350"
                    r="125"
                    stroke="white"
                    strokeWidth="2"
                    fill="transparent"
                  />
                </svg>
              </div>
            );
            
            grid.push(boatSquare);
          }
        });
  
        // display rsu in the grid
        rsu.forEach((rsu) => {
          if (rsu.position[0] === i && rsu.position[1] === j) {
            const rsuSquare = (
              // put an icon in the square
              <div
                className="square rsu"
                style={{ top: i * side, left: j * side }}
              >
                <Icon icon="devicon:towergit" width="80" height="80" />
                {/* Add circle with radius 5 */}
                <svg
                  className="circle"
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%, -50%)",
                  }}
                  height="700"
                  width="700"
                >
                  <circle
                    cx="350"
                    cy="350"
                    r="125"
                    stroke="white"
                    strokeWidth="2"
                    fill="transparent"
                  />
                </svg>
              </div>

            );
            grid.push(rsuSquare);
          }
        });

        if(sensor.length === 0 && boats.length === 0){
          const square = (
            <div
              className="square"
              style={{ top: i * side, left: j * side }}
            >
            </div>
          );
          grid.push(square);
        }
      }
    }
    setSquares(grid);
  };
  

  const loadJson = async () => {
    // setBoats([]); // remove all boats from state
    try{
      const response = await fetch('http://localhost:8080/boat');
      const data = await response.json();
      setConnection(true);
      setBoats([]); // Remove old boats from state
      const newBoats = [];
      for (const id in data) {
        const position = data[id];
        if (newBoats.some((boat) => boat.id === Number(id))) {
          // if true, remove the boat from newBoats
          continue;
        }
        newBoats.push({ id: Number(id), position });
      }
      setConnection(true);
      setBoats(newBoats);
    }catch(error){
      console.log("No connection to the API");
      setConnection(false);
    }
  };

  useEffect(() => {
    createGrid();  // eslint-disable-next-line 
  }, [boats]);

 
      
  const loadWatcher = async () => {
    try{
      const response = await fetch('http://localhost:8080/perimeter');
      const data = await response.json();
      // if data is empty, return
      if (data.length === 0) {
        return;
      }
      setConnection(true);
      setPerimeter(data);
    }catch(error){
      console.log("No connection to the API");
      setConnection(false);
    }

    try{
      const response = await fetch('http://localhost:8080/pickedsensor');
      const data = await response.json();
      // if data is empty, return
      if (data.length === 0) {
        return;
      }
      // data is type {"3": [16.0, 2.0], "2": [16.0, 8.0], "1": [21.0, 2.0]}
      setConnection(true);
      setPickedSensor(data);
      
    }catch(error){
      console.log("No connection to the API");
      setConnection(false);
    }
  };
      

  const showTable = (table) => {
    // get the table
    const tableElement = document.querySelector(`.${table}`);
    if (tableElement.style.display === "table") {
      // if true, hide the table
      tableElement.style.display = "none";
    }else if (tableElement.style.display === "none") {
      // if false, show the table
      tableElement.style.display = "table";
    }else{
      // if false, show the table
      tableElement.style.display = "none";
      if(table === "data"){
        document.querySelector(`.footer`).style.display = "none";
      }
    }
  };
  
  const getSensorIDbyPosition = (position) => {
    // position = [25.0,46.0]

    // position is a string
    const positionString = position.key;
    // remove the [ and ] from the string
    const positionString2 = positionString.replace('[', '');
    const positionString3 = positionString2.replace(']', '');
    // split the string in 2
    const positionString4 = positionString3.split(',');
    // convert the string to number
    
    // compare strings
    for (let i = 0; i < sensor.length; i++) {
      if (Number(sensor[i].position[0]) === Number(positionString4[0]) && Number(sensor[i].position[1]) === Number(positionString4[1])) {
        return sensor[i].id+1;
      }
    }

    return -1;
  };

  // every 1 loadJson is called
  useEffect(() => {
    const interval = setInterval(() => {
      loadJson();
      loadstaticInfo();
      loadWatcher();
      getinfo();
    }, 500);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="App">
      <div className="dataduv">
        <table className='data' display='none'>
          <thead>
            <tr>
              <th>SensorID</th>
              <th>Data</th>

            </tr>

          </thead>
          <tbody>
            {Object.keys(info).map((key) => (
              <tr key={key}>
                <td>{getSensorIDbyPosition({key})}</td>
                <td>{Object.keys(info[key]).map((key2) => (
                  key2 + ": " + info[key][key2] + "\n"
                ))}</td>

              </tr>
            ))}
          </tbody>
        </table>


      </div>
      <div className="header">
        {/* button to show an moving window with an table */}
        <button className='button' onClick={() => showTable("boats")}>Boat</button>
        <button className='button' onClick={() => showTable("sensors")}>Sensors</button>
        <button className='button' onClick={() => showTable("comunication")}>Comunication</button>
        <button className='button' onClick={() => showTable("data")}>Data</button>
        <h1>RSA : Automatic Nautical Sensor Data Collection</h1>
      </div>
      <div className='appmain'>
        <div className='container'>
          <div className='container2'>          
          <h1 className='nauticlheader'>Nautical Emulador:</h1>
          <h1 className='nauticlheader'>&nbsp;{connection ? <Icon icon="material-symbols:signal-cellular-alt" color="green" width="20" height="20" /> : <Icon icon="material-symbols:signal-wifi-off-outline" color="red" width="20" height="20"/>}</h1>
          </div>

          <table className='comunication'>
            <thead>
              <tr>
                <th></th> {/* Empty cell for the top-left corner */}
                {boats.map((boat) => (
                  <th key={boat.id}>B{boat.id}</th>
                ))}
                <th key={rsu.id}>BS</th>
              </tr>
            </thead>
            <tbody>
              {boats.map((boat) => (
                <tr key={boat.id}>
                  <td className='tableh'>B{boat.id}</td>
                  {perimeter[boat.id-1].map((value, index) => (
                    <td key={index}>
                      {/* display icon circle */}
                      {value === 1 ? (
                        <Icon icon="mdi:circle" color="green" width="20" height="20" />
                      ) : value === 2 ? (
                        <p></p>
                      ) : value === 0 ? (
                        <Icon icon="mdi:circle" color="red" width="20" height="20" />
                      ) : (
                        <Icon icon="mdi:circle" color="grey" width="20" height="20" />
                      )}
                    </td>
                  ))}
                </tr>
              ))}            
            </tbody>
          </table>

          <table className='boats'>
            <thead>
              <tr>
                <th style={{width: '50%'}}>Boat ID</th>
                <th style={{width: '50%'}}>Position</th>
                <th style={{width: '50%'}}>Picked Sensor</th>
              </tr>
            </thead>
            <tbody>
              {boats.map((boat) => (
                <tr key={boat.id}>
                  <td style={{width: '50%'}}>{boat.id}</td>
                  <td style={{width: '50%'}}>{boat.position[0]},{boat.position[1]}</td>
                  <td style={{width: '50%'}}>{pickedSensor[boat.id] === -1 ? 'Home' : pickedSensor[boat.id] + 1}</td>
                </tr>
              ))}
            </tbody>
          </table>


          {/* table 7x2*/}
          <table className='sensors'>
            <thead>
              <tr>
                <th>Sensor ID</th>
                <th>Position</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {sensor.map((sensor) => (
                <tr key={sensor.id}>
                  <td>{sensor.id+1}</td>
                  <td>{sensor.position[0]},{sensor.position[1]}</td>
                  {/* circle icon */}
                  <td>{getsensor.includes(sensor.id) ? <Icon icon="mdi:circle" color="green" width="20" height="20" /> : <Icon icon="mdi:circle" color="red" width="20" height="20" />}</td>
                </tr>
              ))}
            </tbody>
          </table>

          {/* create an table to display the data for each sensor */}
        </div>
        <div className="grid">{squares}</div>
      </div>
      <div className="footer">
          <p className='footer_word'>Created by: Bruno Lemos & Tiago Marques</p>
          <p className='footer_word'>Universidade de Aveiro</p>
      </div>
    </div>
  );
}

export default App;
