import React, {useState, useEffect} from 'react';
import './CarReview.css';
import { Icon } from '@iconify/react';
import {motion} from 'framer-motion';
import Reviews from '../../database/reviews.json';
import Embed_reviews from './Embed_reviews';


function CarReview({carobject, setopenreview}) {

  const [noReviews, setNoReviews] = useState(false);

  //Review Json into array
  var rev_array = [];
  Object.keys(Reviews).forEach(function (key) {
      rev_array.push(Reviews[key]);

  });
  //Filter reviews based on input
  const listReviews = rev_array.filter((item) => {
    
    if(item.nome === carobject.nome && item.marca === carobject.marca && item.modelo === carobject.modelo && item.ano === carobject.ano){ 
        return item
    }
    else {
        return null
    }
}).map((item,key) => 
  <Embed_reviews icon={'heart'} title={item.autor +  ' - ' + item.marca + " " + item.modelo + '(' + item.ano + ')'} description={item.comentario} image={item.imagem}></Embed_reviews>
               
);

  //If there are no reviews in listReviews, set noReviews to true using setNoReviews and useEffect
  useEffect(() => {
      if(listReviews.length === 0){
          setNoReviews(true);
      } else {
          setNoReviews(false);
      }
  }
  , [listReviews]);


  return (
    <motion.div 
    animate={{y:0}}
    initial={{y:1000}} 
    exit={{scale:0.2, opacity:0}}
    transition={{ type: "spring", stiffness: 400, damping: 30}}
    className='carReview'>
        
        <div className='carReview-container'>
          <div className='carReview-title'>
            <div div className='closeButton-div'>
              <Icon icon="ep:close-bold" onClick={() => {setopenreview(false)}} className='closeButton-btn'/>
            </div>
            {carobject.marca + " " + carobject.modelo + " (" + carobject.ano + ") Reviews"}
            
          </div>
          <div className='Comments-car'>
            {listReviews}
            {noReviews ? <div className='noReviews'>No reviews yet</div> : null}
          </div>
        </div>
        
        
    </motion.div>
    
  )
}

export default CarReview

