import React from "react";
import './ReportAd.css'
import { Icon } from '@iconify/react';
import {motion, AnimatePresence} from 'framer-motion'
import { useNavigate } from 'react-router-dom';

function ReportAd(props) {

    let navigate = useNavigate();

    const onClickReport = event => {


        event.preventDefault();

        if (document.getElementById("report-reason").value === "") {
            alert("Please write a reason");
            return;
        }
        
        const data = new FormData();
        console.log(props.carObject.marca);
        data.append("brand", props.carObject.marca);
        data.append("model", props.carObject.modelo);
        data.append("image", props.carObject.imagem);
        console.log(data)
        
        //send data to server 'http://localhost:5000/api/deletecar'
        fetch('http://localhost:5000/api/deletecar', {
            method: 'POST',
            body: data,
            mode: 'no-cors',
        }).then(res => {
            console.log(res);
        })
        props.setReportAd(false);
        window.location.reload(false);
    }

  return (
  <motion.div className="butcomp" >
        {<div className='base'>
            <div className='seta_test' onClick={() => props.setReportAd(false)}>
                <Icon icon="akar-icons:arrow-left"  height="25"/>
            </div>
            <div className='reportad'>Report announcements</div>
            <input className="reporttxt" type="text" name="name" id="report-reason" style={{fontSize:20, textAlign:'center'}}/>
            <div className='enviartxt'>
                <h1 className="submitbtn" onClick={onClickReport}>Submit</h1>
            </div>
        </div>}
    </motion.div>
    );
}

export default ReportAd;