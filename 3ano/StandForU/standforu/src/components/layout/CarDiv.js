import React from "react";
import './CarDiv.css'
import {motion} from 'framer-motion';
import { Icon } from '@iconify/react';
import {ToastContainer,toast,Zoom,Bounce} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import axios from "axios";

function CarDiv(props) {
  const { image,profile, info } = props;
  const [apagar,setapagar] = React.useState(true);
  const [editar,setedit] = React.useState(true);
  const deleteannouncement = () => {
    setapagar(!apagar);
    toast.warn("Do you want to delete this announcement?");
  }
  const editannouncement = () => {
    setedit(!editar);
  }
  console.log("apagar"+apagar);
  console.log("editar"+editar);



  return (
    <motion.div animate={{opacity : 1, y:-10}} initial={{opacity:0}} exit={{opacity:0, y:10}} transition={{ duration:0.3}} className="carDiv">
      <img className="cardiv-image" src={require('../../images/' + image)} alt={image}/>
      <div className="info">
        {info}
      </div>
      <Icon onClick={deleteannouncement} visibility={profile?"visible":"hidden"} icon="bi:trash" className="caixote"/>
      <Icon onClick={editannouncement} visibility={profile?"visible":"hidden"} icon="ant-design:edit-twotone" className="editar"/>
      <div className="overlap-group">
        <div className="rectangle-10"></div>
        <div className="extra">
          +INFO
        </div>
      </div>
    </motion.div>
  );  
}

export default CarDiv;