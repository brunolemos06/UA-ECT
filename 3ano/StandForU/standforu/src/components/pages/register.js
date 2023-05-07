// import React, { Component } from "react";
import {useNavigate} from 'react-router-dom';
import Navbar from "../layout/Navbar"
import'./register.css'
import {Link} from 'react-router-dom';
import { Icon } from '@iconify/react';
import './Sellcar.css'
import React from 'react';


class register extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
          image: null
        };
        this.openAd = false;
        this.color_var = "#FFFFFF";
       // if we are using arrow function binding in not required
        this.onImageChange = this.onImageChange.bind(this);
      }
      saveImage = (event) => {
        /* console "saveimage" */
        console.log("saveimage");
      }
      
      onImageChange = event => {
        if (event.target.files && event.target.files[0]) {
          /* openAd = true; */
          this.openAd = true;
          let img = event.target.files[0];
          this.setState({
            image: URL.createObjectURL(img)
          });
        }
      };


    render(){
        return (
            <div className="loginpage">
                <Navbar link="register"/>
                <div id="split_left">
                    <div class="left">-
                        <h1 className="logintitle">Register</h1>
                        <input type="input" class="form__field1" placeholder="" name="username" id='username' required />
                        <label for="username" class="form__label1"><Icon icon="ant-design:user-outlined" color="#4fbfb9" />User</label>

                        <input type="input" class="form__field2" placeholder="" name="password" id='password' required />
                        <label for="password" class="form__label2"><Icon icon="clarity:email-solid" color="#4fbfb9" />Email</label>

                        <input type="password" class="form__field3" placeholder="" name="password" id='password' required />
                        <label for="password" class="form__label3"><Icon icon="carbon:password" color="#4fbfb9" />Pass</label>

                        <input type="password" class="form__field10" placeholder="" name="password" id='password' required />
                        <label for="password" class="form__label10"><Icon icon="line-md:confirm-circle" color="#4fbfb9" />Confirm Password</label>

                        <input type="input" class="form__field11" placeholder="" name="password" id='password' required />
                        <label for="password" class="form__label11"><Icon icon="ant-design:phone-filled" color="#4fbfb9" />Phone Number</label>

                        <div className="label_btn">
                          {/* <div className="btn_login_div" onClick={WithNavigate}><div className= "btn_login" style={{color:this.color_var}}>login</div></div>   */}
                          <div className="btn_register_div"><Link to='/login' className= "btn_register" style={{color:this.color_var}}>Register</Link></div>
                        </div>
                    </div>
                </div>
                
                <div id="split_right">
                    <div class="centered2">
                        <div className="iconphoto2">
                            {!this.openAd && <Icon icon="carbon:user-avatar-filled-alt" color="#4fbfb9" width="200" />}
                        </div>
                        <div className="div-upload2">
                            <img className="upload-image2" alt="" src={this.state.image} />
                        </div>
                        <label className="file2"><input type="file" name="myImage" onChange={this.onImageChange}/>Upload Photo</label>

                        <textarea  type="input" class="form__field12" placeholder="" name="description" id='description' required  cols="40" rows="5"></textarea>
                        <label for="description" class="form__label12"><Icon icon="fluent:text-description-20-filled" color="#4fbfb9" />Description</label>
                    </div>
                </div>
            </div>
            

        );
    }
}

export  default register;