import React from 'react'
import Navbar from '../layout/Navbar' 
import './Makereview.css'
import { useNavigate } from "react-router-dom"; 
import {ToastContainer,toast,Zoom,Bounce} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css'; 
function Makeareview(props) {
  let navigate = useNavigate();
  const handleSubmit = (e) => {
    e.preventDefault();
    //verificar que o input brand, model, year, review não estão vazios
    if(document.getElementById('brand').value === "" || document.getElementById('model').value === "" || document.getElementById('year').value === "" || document.getElementById('review').value === ""){
      toast.error('Please fill all the fields', {
        position: "top-right",
        autoClose: 1300,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: false,
        draggable: true,
        progress: undefined,
        });
    }else{
      toast.success("Review added successfully");
      navigate(`/`);
    }
  }

  return (
    <div className='Review_page' >
      <ToastContainer/>
        <Navbar link="makeareview" loggedIn={props.loggedIn}/>
        <div className='Review_page_container_left'>
            <div className='components'>

              <p className='title'>
              Add Review
              </p>

              <p>
              In this page you can make a comment about a car
              </p>

              <p>
              <input type="input" class="MR_form__field1" placeholder="" name="brand" id='brand' required maxLength={30}/>
              <label for="brand" class="MR_form__label1">Brand</label>
              </p>
              
              <p>
              <input type="input" class="MR_form__field2" placeholder="" name="model" id='model' required maxLength={30}/>
              <label for="model" class="MR_form__label2">Model</label>
              </p>

              <p>
              <input type="date" class="MR_form__field3" placeholder="" name="year" id='year' required maxLength={4} />
              {/* <label for="year" class="MR_form__label3">Year</label> */}
              </p>

              <p>
              <textarea  type="input" class="MR_form__field4" placeholder="" name="review" id='review' required  cols="40" rows="5" maxLength={200}></textarea>
              <label for="review" class="MR_form__label4">Review</label>
              </p>
            
              <button onClick={handleSubmit} className='MR_btn'>Submit</button>

            </div>
        </div>
    </div>
    
  )
}

export default Makeareview
