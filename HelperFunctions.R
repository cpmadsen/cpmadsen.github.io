# Helper functions.


# Parallax HTML script.
parallax_image = function(image_path = NA){
  
  div(tags$style(paste0('.parallax {
  /* The image used */
  background-image: url(',image_path,');

  /* Set a specific height */
  min-height: 500px; 

  /* Create the parallax scrolling effect */
  background-attachment: fixed;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}')),
      div(class = 'parallax')
  )
}
