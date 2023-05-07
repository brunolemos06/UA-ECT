import {React,useState, useEffect} from "react";
import Navbar from "../components/Navbar";
import './Sellcar.css';
// import './login.css';
// import './register.css';
import { Icon } from '@iconify/react';
import {Link, useNavigate} from 'react-router-dom';


function SellCar(props){

    let navigate = useNavigate();

    //run once when the component is mounted
    useEffect(() => {
        if(!props.loggedIn){
            navigate('/login');
        }
    }
    , [props.loggedIn]);
    const [openAd, setopenAd] = useState(false);
    const [state, setState]   = useState({image:null})

    
    const onImageChange = event => {
        if (event.target.files && event.target.files[0]) {
        /* openAd = true; */
        setopenAd(true);

        var img = event.target.files[0];
        setState({image: URL.createObjectURL(img)});
        }
    };

    const handleSubmit = event => {
        event.preventDefault();
        const data = new FormData();
        data.append('image', document.getElementById('image').files[0]);
        data.append('brand', document.getElementById('brand').value);
        data.append('model', document.getElementById('model').value);
        data.append('year', document.getElementById('year').value);
        data.append('price', document.getElementById('price').value);
        data.append('description', document.getElementById('description').value);
        data.append('fuel', document.getElementById('fuel').value);
        data.append('horsepower', document.getElementById('horse_power').value);
        data.append('kms' , document.getElementById('kms').value);

        fetch('http://localhost:5000/api/sellcar', {
            method: 'POST',
            body: data,
            mode: 'no-cors',
        }).then(res => {
            console.log(res);
            navigate('/');
        })
    }


    return (
      <div>
          <Navbar link="sellcar" loggedIn={props.loggedIn}/>
          
            {props.user !== "admin" && <div id="split_left">
                <div className="left">
                    <h1>Sell a car</h1>
                    <input type="input" className="form__field1" placeholder="" name="brand" id='brand' required />
                    <label for="brand" className="form__label1">Brand</label>

                    <input type="input" className="form__field2" placeholder="" name="model" id='model' required />
                    <label for="model" className="form__label2">Model</label>

                    <input type="input" className="form__field3" placeholder="" name="kms" id='kms' required />
                    <label for="kms" className="form__label3">KMS</label>

                    <input type="input" className="form__field4" placeholder="" name="priece" id='price' required />
                    <label for="priece" className="form__label4">Price</label>

                    <input type="input" className="form__field5" placeholder="" name="year" id='year' required />
                    <label for="year" className="form__label5">Year</label>

                    <input type="input" className="form__field6" placeholder="" name="fuel" id='fuel' required />
                    <label for="fuel" className="form__label6">Fuel</label>

                    <input type="input" className="form__field7" placeholder="" name="engine" id='engine' required />
                    <label for="engine" className="form__label7">Engine</label>

                    <input type="input" className="form__field8" placeholder="" name="horse_power" id='horse_power' required />
                    <label for="horse_power" className="form__label8">Horse Power</label>

                    <textarea  type="input" className="form__field15" placeholder="" name="description" id='description' required  cols="40" rows="5"></textarea>
                    <label for="description" className="form__label15">Description</label>
                </div>
            </div>}
            
            {props.user !== "admin" && <div id="split_right">
                <div className="centered">
                  <div className="iconphoto" >
                    {!openAd && <Icon icon="bytesize:photo" color="#640064" height="100%"/>} 
                  </div>
                  <div className="div-upload" style={{backgroundColor: openAd? 'transparent' : 'transparent'}}>
                    <img className="upload-image" alt="" src={state.image} />
                  </div>
                  <div className="space" style={{backgroundColor: openAd? 'transparent' : 'transparent'}} ></div>
                  <div className="upload_tbn" style={{backgroundColor: openAd? 'transparent' : 'transparent'}}>
                    <label className="file"><input type="file" name="myImage"  id ="image" onChange={onImageChange} />Upload Photo</label>
                  </div>
                  <div className="btn_sub_div"><input type="submit" className= "btn_sub" style={{color:"#FFFFFF"}} onClick={handleSubmit}/></div>
                </div>
            </div>}

            {props.user === "admin" &&
              <div>
                <h1 style={{position:'absolute', left:'10vw', top:'20vh'}}>You have to switch accounts to sell a car</h1>
              </div>
            }
          
      </div>
    )
}

export default SellCar;
