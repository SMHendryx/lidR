ui_treeviewer = function(.las)
{
  ui = shiny::shinyUI(shiny::pageWithSidebar(
    shiny::headerPanel("Tree viewer"),

    shiny::sidebarPanel(
      shiny::sliderInput("tree", "Tree:", min = 0, max = max(.las$treeID), value = 0, step = 1)
    ),

    shiny::mainPanel(shinyRGL::webGLOutput("myWebGL"))
  ))

  server = shiny::shinyServer(function(input, output) {

    output$myWebGL <- shinyRGL::renderWebGL({
    tree = suppressWarnings(lasfilter(.las, treeID == input$tree))
    plot(tree, add = TRUE)
    })
  })

  shiny::shinyApp(ui, server)
}
