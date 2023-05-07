import React,{useEffect} from "react";
import { Icon } from '@iconify/react';
import './Star.css'

function Star(props){
    
        return (
            <div className='star'>
                <h1 className="reviewsevaluation" style={{fontWeight:'bold'}}>Reviews Evaluation</h1>
                <div className="estrelas">
                    {props.stars>=1 &&<Icon  className="umestrela" icon="ant-design:star-filled" color="#ffd233" height="20" />}
                    {props.stars>=2 &&<Icon className="doisestrela" icon="ant-design:star-filled" color="#ffd233" height="20" />}
                    {props.stars>=3 &&<Icon className="tresestrela" icon="ant-design:star-filled" color="#ffd233" height="20" />}
                    {props.stars>=4 &&<Icon className="quatroestrela" icon="ant-design:star-filled" color="#ffd233" height="20" />}
                    {props.stars>=5 && <Icon className="cincoestrela" icon="ant-design:star-filled" color="#ffd233" height="20" />}
                </div>
            </div>

        )
};


export default Star;