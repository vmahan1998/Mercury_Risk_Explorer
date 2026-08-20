tab_home_ui <- function(id = "home") {
  ns <- NS(id)
  
  fluidPage(
    shinyjs::useShinyjs(),
    
    div(
      class = "home-intro",
      
      fluidRow(
        column(
          12,
          div(
            class = "hero-header",
            h1("Purpose of this Application", class = "hero-title hero-title-overlay")
          )
        )
      ),
      
      fluidRow(
        
        column(
          7,
          div(
            class = "hydro-map-wrap",
            
            leafletOutput(ns("hydro_map"), width = "100%", height = "650px"),
            
            div(
              class = "hydro-overlay-left tile-white",
              style = "margin-top: 375px;",
              div(
                class = "overlay-section",
                h3("Penobscot River Estuary, ME", class = "tile-title"),
                p(
                  "This interactive map provides geographic context for this application. Use the layer controls to view historical and existing dams, and the primary legacy mercury point source within the estuary.",
                  class = "helper-text"
                )
              )
            )
          ),
          
          div(class = "section-space")
        ),
        
        column(
          5,
          style = "margin-top: 40px;",
          h3("Overview", class = "tile-title", style = "text-align: center;"),
          p(
            "The Mercury Risk Explorer was created to communicate how mercury-bound particles behave and how their transport, resuspension, and biological interactions shape risk for anadromous fish. By linking material transport processes with habitat- and behavior-associated risk, the application explores when, where, and how mercury could pose risk under the modeled conditions.",
            class = "hero-subtitle"
          ),
          
          p(
            "In estuaries, tides, river flow, and sediment movement constantly reshape where contaminants are stored, resuspended, and transported. Because anadromous fish rely on these environments for migration, spawning, and early life stages, their exposure to contamination changes over space and time rather than remaining fixed.",
            class = "hero-subtitle"
          ),
          
          p(
            "This application focuses on the Penobscot River Estuary in Maine, a macrotidal estuary where large tidal ranges strongly influence water movement, sediment transport, and contaminant redistribution. The application integrates scientific data and modeling to show how these interactions shape when and where exposure occurs for river herring, allowing users to explore how contamination risk differs across life stages and how movement and timing influence exposure pathways.",
            class = "hero-subtitle"
          ),
          
          p(
            "The tool was developed as a community-facing companion to a doctoral dissertation, with the goal of making complex environmental risk processes more transparent, understandable, and usable for education, discussion, and decision-making. It is intended to support informed choices related to fisheries management, habitat restoration, and infrastructure planning.",
            class = "hero-subtitle"
          )
        ),
        
        column(
          6,
          style = "margin-top: 80px;",
          h3("Dynamics of Contamination Risk in Estuaries", class = "tile-title", style = "text-align: center;"),
          
          p(
            "In the Penobscot River Estuary, strong tidal currents, asymmetric tidal behavior, and seasonal variability influence the direction and magnitude of sediment transport. These processes determine where contaminated sediments accumulate, when they are resuspended, and whether mercury remains in inorganic form or is converted to methylmercury within aerobic and anaerobic sediment environments.",
            class = "helper-text"
          ),
          
          p(
            "Anadromous fish interact with these dynamic conditions as they migrate, stage, spawn, and rear within the estuary. Because different life stages occupy distinct habitats and move through the system at different times, exposure to contamination is uneven and context dependent. Risk depends on the overlap between biologically suitable habitat, contaminated sediments, and the timing and pathways of movement through the estuary.",
            class = "helper-text"
          ),
          
          p(
            "This application integrates hydrodynamic transport, sediment associated contamination, habitat suitability, and fish behavior to illustrate how contamination risk develops in the Penobscot River Estuary, providing a framework for exploring how physical processes and biological decisions interact to shape exposure pathways and ecological risk.",
            class = "helper-text"
          )
        ),
        
        column(
          6,
          tags$figure(
            class = "hero-figure",
            div(
              class = "hero-image-wrap",
              tags$img(
                src = "Overview_Figure.png",
                class = "hero-image",
                style = "margin-top: 50px; height: 450px;",
                alt = "Conceptual overview of transport, habitat, and exposure processes in the Penobscot River Estuary"
              )
            ),
            tags$figcaption(
              class = "hero-figure-caption",
              "Conceptual overview of spatial and temporal transport processes, sediment dynamics, and behaviorally mediated exposure pathways for anadromous fish in a macrotidal estuary."
            )
          )
        )
      )
    ),
    
    div(class = "section-space"),
    
    # HOW TO USE: white tile with image on the LEFT and icons
    card(
      class = "tile-white tile-pop",
      card_body(
        fluidRow(
          # IMAGE COLUMN (LEFT)
          column(
            5,
            div(
              class = "side-image-wrap",
              tags$img(
                src = "web_app_intro.png",
                class = "side-image",
                alt = "Conceptual workflow linking transport, habitat, and exposure"
              )
            )
          ),
          
          # TEXT COLUMN (RIGHT)
          column(
            7,
            div(
              div(
                class = "how-to-text",
                style = "max-width: 700px; margin: 0 auto;",
                h3(
                  "How to use this App",
                  class = "tile-title",
                  style = "text-align: center; font-weight: 700; line-height: 1.25;"
                )
              ),
              
              tags$ol(
                class = "tile-list",
                
                tags$li(
                  icon("book-open"),
                  tags$b(" Background: "),
                  "Provides system context, objectives, and modeling assumptions."
                ),
                
                tags$li(
                  icon("fish"),
                  tags$b(" Mercury Toxicity in Fish: "),
                  "Introduces why anadromous fish are of special interest for contamination risk."
                ),
                
                tags$li(
                  icon("water"),
                  tags$b(" Hydrodynamics: "),
                  "Summarizes tidal flow regimes and material transport conditions."
                ),
                
                tags$li(
                  icon("layer-group"),
                  tags$b(" Life-Stage Risk: "),
                  "Compares potential exposure opportunity across life stages."
                ),
                
                tags$li(
                  icon("route"),
                  tags$b(" Behavior-Mediated Risk: "),
                  "Shows how movement and behavior shape exposure pathways."
                ),
                
                tags$li(
                  icon("users"),
                  tags$b(" Authors: "),
                  "Includes authorship, collaborators, and acknowledgements."
                )
              )
            )
          )
        )
      )
    ),
    
    div(class = "section-space-small"),
    
    fluidRow(
      column(
        12,
        h3(
          "Statement of Use and Disclaimer",
          class = "tile-title",
          style = "text-align:center;"
        ),
        
        div(class = "section-space-small"),
        
        p(
          "This application is provided for research communication, transparency, and educational use. Outputs presented throughout the application represent simulated estimates and spatial overlays generated from calibrated hydrodynamic and ecological models. Results are conditional on the assumptions, parameter values, behavioral rules, environmental forcing, and scenario configurations used in the analysis, and are intended to support interpretation of potential ecological patterns, mechanisms, and contaminant exposure pathways. These outputs should not be interpreted as direct observations or predictions of actual fish behavior, habitat use, contaminant exposure, mercury toxicity, or mercury methylation rates.",
          style = "font-size:18px; text-align:center; font-style:italic; line-height:1.4;"
        )
      )
    ),
    
    div(class = "section-space-small"),
    
    fluidRow(
      column(
        12,
        card(
          class = "tile-white tile-pop",
          card_body(
            
            div(
              class = "how-to-text",
              style = "max-width: 700px; margin: 0 auto;",
              h3(
                "Frequently Asked Questions",
                class = "tile-title",
                style = "text-align: center; font-weight: 700; line-height: 1.25;"
              )
            ),
            
            tags$div(
              class = "faq-accordion",
              
              tags$details(
                open = FALSE,
                tags$summary(tags$strong("What does this app show?")),
                tags$p(
                  "This app integrates hydrodynamic modeling, habitat suitability modeling, and sediment methylmercury data to identify where and when river herring are most likely to encounter contamination in the Penobscot River Estuary.",
                  class = "helper-text"
                )
              ),
              div(class = "section-space-small"),
              
              tags$details(
                open = FALSE,
                tags$summary(tags$strong("Does high risk mean fish are unsafe to eat here?")),
                tags$p(
                  "No. The risk metrics shown here represent exposure potential within suitable habitat, not direct measurements of fish tissue contamination at specific locations.",
                  class = "helper-text"
                )
              ),
              div(class = "section-space-small"),
              
              tags$details(
                open = FALSE,
                tags$summary(tags$strong("Why focus on methylmercury?")),
                tags$p(
                  "Methylmercury is the form of mercury that bioaccumulates in food webs and causes biological effects, making it the most relevant metric for ecological risk assessment.",
                  class = "helper-text"
                )
              ),
              div(class = "section-space-small"),
              
              tags$details(
                open = FALSE,
                tags$summary(tags$strong("Why does risk change through the season?")),
                tags$p(
                  "Risk changes as hydrodynamic conditions redistribute sediment associated mercury and as suitable habitat expands or contracts across life stages.",
                  class = "helper-text"
                )
              ),
              div(class = "section-space-small"),
              
              tags$details(
                open = FALSE,
                tags$summary(tags$strong("How can this information support management decisions?")),
                tags$p(
                  "The results help identify persistent risk hotspots where remediation or restoration could reduce exposure across multiple life stages simultaneously.",
                  class = "helper-text"
                )
              )
            )
          )
        )
      )
    ),
    
    div(class = "section-space-small"),
    
    # RELATED LINKS: 4 horizontal tiles
    div(
      class = "links-row-title",
      h3("Related links", class = "tile-title", style = "text-align: center;")
    ),
    
    div(class = "section-space-small"),
    
    fluidRow(
      column(
        3,
        card(
          class = "link-tile",
          card_body(
            div(
              class = "link-head",
              tags$span(icon("fish-fins"), class = "link-icon"),
              h4("GoFish", class = "link-title")
            ),
            p("Behavioral library and documentation.", class = "link-desc"),
            tags$a("Learn More", href = "https://vmahan1998.github.io/GoFish/", target = "_blank", class = "link-btn"),
            tags$a(href = "https://vmahan1998.github.io/GoFish/", target = "_blank", class = "stretched-link", `aria-label` = "Open GoFish")
          )
        )
      ),
      column(
        3,
        card(
          class = "link-tile",
          card_body(
            div(
              class = "link-head",
              tags$span(icon("file-lines"), class = "link-icon"),
              h4("Dissertation Link", class = "link-title")
            ),
            p("Code, figures, and reproducible workflows.", class = "link-desc"),
            tags$a("Read More", href = "https://github.com/", target = "_blank", class = "link-btn"),
            tags$a(href = "https://github.com/", target = "_blank", class = "stretched-link", `aria-label` = "Open Dissertation link")
          )
        )
      ),
      column(
        3,
        card(
          class = "link-tile",
          card_body(
            div(
              class = "link-head",
              tags$span(icon("layer-group"), class = "link-icon"),
              h4("P-MEM", class = "link-title")
            ),
            p("Penobscot Mercury Exposure Model.", class = "link-desc"),
            tags$a("Learn More", href = "https://zenodo.org/records/19483469", target = "_blank", class = "link-btn"),
            tags$a(href = "https://zenodo.org/records/19483469", target = "_blank", class = "stretched-link", `aria-label` = "Open RHMM link")
          )
        )
      ),
      column(
        3,
        card(
          class = "link-tile",
          card_body(
            div(
              class = "link-head",
              tags$span(icon("envelope"), class = "link-icon"),
              h4("Contact Me", class = "link-title")
            ),
            p("Email and project contact information.", class = "link-desc"),
            tags$a("Send an Email", href = "mailto:mahan.vanessa98@gmail.com", class = "link-btn"),
            tags$a(href = "mailto:mahan.vanessa98@gmail.com", class = "stretched-link", `aria-label` = "Email me")
          )
        )
      )
    )
  )
}

tab_home_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # -----------------------------
    # Markers
    # -----------------------------
    sites <- data.frame(
      name = c("Hampden Field Site", "Bangor Field Site"),
      role = c("Near the flood limit under high discharge", "Typically above the flood limit"),
      lat = c(44.747494, 44.797859),
      lng = c(-68.821437, -68.766238)
    )
    
    dams <- data.frame(
      name = c("Veazie Dam", "Great Works Dam", "Milford Dam", "West Enfield Dam"),
      status = c("Demolished (2013)", "Demolished (2012)", "Operational", "Operational – discharge reference site"),
      lat = c(44.83248, 44.92046, 44.94074, 45.250280),
      lng = c(-68.70094, -68.63275, -68.64781, -68.649060),
      stringsAsFactors = FALSE
    )
    
    pollution <- data.frame(
      name = "Mallinckrodt Facility (Former HoltraChem)",
      role = "Historical mercury point source",
      lat = 44 + 44/60 + 25.15/3600,
      lng = -(68 + 49/60 + 34.26/3600)
    )
    
    dam_icon <- awesomeIcons(
      icon = "water", library = "fa",
      iconColor = "white", markerColor = "gray"
    )
    
    pollution_icon <- awesomeIcons(
      icon = "industry", library = "fa",
      iconColor = "white", markerColor = "red"
    )
    
    # Fit bounds padding
    pad_west  <- 0.20
    pad_east  <- 0.03
    pad_south <- 0.20
    pad_north <- 0.20
    
    lng_vals <- c(sites$lng, pollution$lng)
    lat_vals <- c(sites$lat, pollution$lat)
    
    # -----------------------------
    # Load rasters once
    # -----------------------------
    r_mercury       <- terra::rast("data/k_mercury.tif")
    r_methylmercury <- terra::rast("data/k_methylmercury.tif")
    
    r_mercury[r_mercury <= 0]             <- NA
    r_methylmercury[r_methylmercury <= 0] <- NA
    
    r_mercury_ll       <- terra::project(r_mercury, "EPSG:4326")
    r_methylmercury_ll <- terra::project(r_methylmercury, "EPSG:4326")
    
    # Palettes
    rng_hg   <- terra::global(r_mercury_ll, range, na.rm = TRUE)[1, ]
    rng_mehg <- terra::global(r_methylmercury_ll, range, na.rm = TRUE)[1, ]
    
    pal_hg <- leaflet::colorNumeric(
      palette  = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
      domain   = rng_hg,
      na.color = "transparent"
    )
    
    pal_mehg <- leaflet::colorNumeric(
      palette  = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
      domain   = rng_mehg,
      na.color = "transparent"
    )
    
    # -----------------------------
    # Map
    # -----------------------------
    output$hydro_map <- renderLeaflet({
      leaflet() |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldTerrain, group = "Terrain") |>
        
        # Rasters as overlays
        addRasterImage(r_mercury_ll, colors = pal_hg, opacity = 0.65, project = FALSE, group = "Mercury (THg)") |>
        addRasterImage(r_methylmercury_ll, colors = pal_mehg, opacity = 0.65, project = FALSE, group = "Methylmercury (MeHg)") |>
        
        # Markers as overlays
        addAwesomeMarkers(
          data = dams, lng = ~lng, lat = ~lat,
          icon = dam_icon, label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>Status: ", status),
          group = "Dams"
        ) |>
        addAwesomeMarkers(
          data = pollution, lng = ~lng, lat = ~lat,
          icon = pollution_icon, label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>", role),
          group = "Pollution Sources"
        ) |>
        
        addLayersControl(
          baseGroups = c("Satellite", "Light", "Terrain"),
          overlayGroups = c("Mercury (THg)", "Methylmercury (MeHg)", "Dams", "Pollution Sources"),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        
        fitBounds(
          lng1 = min(lng_vals) - pad_west,
          lat1 = min(lat_vals) - pad_south,
          lng2 = max(lng_vals) + pad_east,
          lat2 = max(lat_vals) + pad_north
        ) |>
        
        # Default: show MeHg, hide THg
        hideGroup(c("Mercury (THg)", "Methylmercury (MeHg)")) |>
        
        # Default legend for MeHg at load
        addLegend(
          pal = pal_mehg,
          values = seq(rng_mehg[[1]], rng_mehg[[2]], length.out = 7),
          title = "Methylmercury (MeHg)",
          opacity = 1,
          position = "bottomright",
          layerId = "legend_mehg"
        )
    })
    
    # -----------------------------
    # Legends: sync to visible overlay groups
    # -----------------------------
    observe({
      grps <- input$hydro_map_groups
      if (is.null(grps)) grps <- character(0)
      
      proxy <- leafletProxy("hydro_map", session) |>
        removeControl("legend_hg") |>
        removeControl("legend_mehg")
      
      if ("Mercury (THg)" %in% grps) {
        proxy <- proxy |>
          addLegend(
            pal = pal_hg,
            values = seq(rng_hg[[1]], rng_hg[[2]], length.out = 7),
            title = "Total Mercury (THg)",
            opacity = 1,
            position = "bottomright",
            layerId = "legend_hg"
          )
      }
      
      if ("Methylmercury (MeHg)" %in% grps) {
        proxy <- proxy |>
          addLegend(
            pal = pal_mehg,
            values = seq(rng_mehg[[1]], rng_mehg[[2]], length.out = 7),
            title = "Methylmercury (MeHg)",
            opacity = 1,
            position = "bottomright",
            layerId = "legend_mehg"
          )
      }
    })
  })
}
