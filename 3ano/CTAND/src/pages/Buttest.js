import React,{useEffect} from "react";
import './Buttest.css'
import { Icon } from '@iconify/react';
import {motion, AnimatePresence} from 'framer-motion'
function Buttest(props) {
    
  return (
    <motion.div className="butcomp">
        <div className='base'>
            <div className='seta_test' onClick={() => props.setTest(false)}>
                <Icon icon="akar-icons:arrow-left"  height="25"/>
            </div>
            <div className='contactar'>Contact agent</div>
                <div className='maisinfo'>Message to agent: Antónia Rocha</div>
                    {/* <div className='linha1'></div> */}
                        <div className='textocomprar'>
                            Hello there, I am interested in test driving this car, please contact me.
                        </div>
                        <div className='enviadopor'>Sent by: João Lemos</div>
                        <div className='email'>Email: joao.lemos@email.com</div>
                        <div className='telefone'>Phone: 913441442</div>
                        <div className='enviar'>
                            <div className='enviartxt' onClick={() => props.setTest(false)}>Send</div>
                        </div>
                {/* <div className='linha2'></div> */}
        </div>
    </motion.div>
  );
}

export default Buttest;