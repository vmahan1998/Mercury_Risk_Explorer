tab_anadromous_ui <- function() {
  tabPanel(
    title = "Anadromous Fish",
    value = "anadromy",
    fluidPage(
      # INTRO: header band (no card)
      div(
        class = "home-intro",
        
        # ---- ROW 1: FULL-WIDTH TITLE BAND ----
        fluidRow(
          column(
            12,
            div(
              class = "hero-header",
              h1("River Herring in the Penobscot River Estuary", class = "hero-title hero-title-overlay")
            )
          )
        ),
        
        # ---- ROW 2: INTRO TEXT (regular text, no card) ----
        fluidRow(
          column(
            12,
            p(
              "This section provides the system context for the Penobscot River Estuary in Maine and summarizes why contamination persists, why anadromous fish are a focal point for exposure risk, and how the datasets and models used in this application fit together.",
              class = "hero-subtitle"
            )
          )
        )
      )
      
    )
  )
}

tab_anadromous_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}

