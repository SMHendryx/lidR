ui_treeviewer = function(.las)
{
  ui = shiny::shinyUI(shiny::pageWithSidebar(

    shiny::headerPanel("Tree viewer"),

    shiny::sidebarPanel(
      shiny::sliderInput("tree", "Tree:", min = 0, max = max(.las$treeID), value = 0, step = 1)
    ),

    shiny::mainPanel(rgl::rglwidgetOutput("myWebGL"))
  ))

  server = shiny::shinyServer(function(input, output) {

    output$myWebGL <- rgl::renderRglwidget({
    tree = suppressWarnings(lasfilter(.las, treeID == input$tree))
    try(rgl.close())
    plot(tree, add = TRUE)
    rglwidget()
    })
  })

  shiny::shinyApp(ui, server)
}