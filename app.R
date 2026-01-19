# remotes::install_github("statnmap/HatchedPolygons")  # or devtools::install_github

library(shiny)
library(bslib)
library(leaflet)
library(terra)
library(dplyr)
library(R.matlab)
library(fontawesome)
library(readr)
library(ggplot2)
library(plotly)
library(shinyjs)
library(sf)
library(sp)
library(HatchedPolygons)
library(ggridges)
library(scales)
library(lubridate)

source("R/tab_home.R")
source("R/tab_background.R")
#source("R/tab_anadromous.R")
source("R/tab_hydrodynamics.R")
source("R/tab_static_risk.R")
source("R/tab_behavioral_risk.R")
source("R/tab_about.R")

ui <- page_navbar(
  title = tagList(
    tags$img(
      src = "vmq.png",
      height = "75px",
      style = "margin-right: 5px; vertical-align: bottom;"
    ),
    tags$span(
      "Mercury Risk Explorer",
      style = "
    font-size: 2.15rem;
    font-weight: 700;
    letter-spacing: 0.3px;
    line-height: 1.2;
    padding-top: 14px;
    padding-bottom: 14px;
    display: inline-block;
  "
    )
    ),
  
  id = "top_nav",
  
  theme = bs_theme(
    version = 5,
    bg = "#0f1f2d",
    fg = "#ffffff",
    primary = "#4fb3d9"
  ),
  
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  navset_tab(
    id = "tabs",
    
    nav_panel("Home", tab_home_ui()),
    nav_panel("Mercury in the Penobscot River Estuary", tab_background_ui()),
    #nav_panel("Migratory Fish", tab_anadromous_ui()),
    nav_panel("Material Transport & Retention", tab_hydrodynamics_ui()),
    nav_panel("Habitat-Associated Risk", tab_static_risk_ui()),
    nav_panel("Behavior-Mediated Risk", tab_behavioral_risk_ui()),
    nav_panel("Authors", tab_about_ui())
  )
)

server <- function(input, output, session) {
  tab_home_server("home")
  tab_background_server("background")
  #tab_anadromous_server("anadromy")  
  tab_hydrodynamics_server("hydro")
  tab_static_risk_server("static")
  tab_behavioral_risk_server("behavior")
  tab_about_server("about")
}

shinyApp(ui, server)
