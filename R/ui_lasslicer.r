ui_lasslicer = function(.las)
{
  canopy = grid_canopy(las, 1)
  ext = extent(.las)
  A = c(ext@xmax, ext@ymin)
  B = c(ext@xmin, ext@ymax)

  ui = shiny::shinyUI(pageWithSidebar(
    shiny::headerPanel("LAS slicer"),

    shiny::sidebarPanel(
      shiny::sliderInput("angle", "Angle:", min= -90, max = 90, value=10, step = 1),
      shiny::sliderInput("height", "Height", min= 0.5, max=99.5, value=0.5, step = 0.5),
      shiny::sliderInput("thickness", "Thinkness:", min= 0.1, max=5, value=1)
    ),

    shiny::mainPanel(shiny::plotOutput("plot", height = 600, width = 600))
  ))

  # Define server logic for slider examples
  server = shiny::shinyServer(function(input, output) {

    output$plot <- shiny::renderPlot({

      angle = pi/2-input$angle*pi/180
      a = 1/tan(angle)

      if(a >= 0) {
        b_min = ext@ymin - a*ext@xmax
        b_max = ext@ymax - a*ext@xmin
      } else {
        b_min = ext@ymin
        b_max = ext@ymax
      }

      b = input$height*(b_max-b_min)/100+b_min
      e = abs(input$thickness/sin(angle))

      slice = suppressWarnings(lasfilter(.las, Y < a * X + b + e, Y > a * X + b - e))

      p1 = ggplot2::ggplot(slice@data, ggplot2::aes(x = X, y = Z, color = Z)) +
           ggplot2::geom_point() +
           ggplot2::ylim(0,50) +
           ggplot2::theme_bw() +
           ggplot2::coord_equal()+
           ggplot2::scale_color_gradientn(colours = height.colors(50))

      p2 = ggplot2::ggplot(canopy, aes(x=X, y=Y)) +
           ggplot2::geom_tile(aes(fill = Z)) +
           ggplot2::coord_equal() +
           ggplot2::scale_fill_gradientn(colours = height.colors(50)) +
           ggplot2::theme_bw() +
           ggplot2::geom_abline(slope = a, intercept = b) +
           ggplot2::geom_abline(slope = a, intercept = b-input$thickness) +
           ggplot2::geom_abline(slope = a, intercept = b+input$thickness)

      gridExtra::grid.arrange(p1, p2, nrow = 2)
    })
  })

  shiny::shinyApp(ui, server)
}
