import React from "react";
import './CarDiv.css'
import {motion} from 'framer-motion';
import { Icon } from '@iconify/react';

function CarDiv(props) {
  const { image, info,trash } = props;
  return (
    <motion.div animate={{opacity : 1, y:-10}} initial={{opacity:0}} exit={{opacity:0, y:10}} transition={{ duration:0.3}} className="carDiv">
      <img className="cardiv-image" src={require('../images/' + image)} alt={image}/>
      {trash &&<Icon className="trash" icon="bx:trash" height="20" />}
      <div className="info">
        {info}
      </div>
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