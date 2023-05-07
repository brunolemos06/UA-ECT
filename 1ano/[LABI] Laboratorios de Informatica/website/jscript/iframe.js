    function select_menu(id, src_link, text_titulo) {
      document.getElementById("text_titulo").textContent=text_titulo;
      document.getElementById("text_frame").setAttribute("src",src_link);
      document.getElementById(id).style.color='#FFA500';
    }

    function unselect_menu(id) {
      document.getElementById(id).style.color='skyblue';
    }
