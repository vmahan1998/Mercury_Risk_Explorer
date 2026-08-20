matlab_datenum_to_posix <- function(x, tz = "America/New_York") {
  out <- as.POSIXct((as.vector(x) - 719529) * 86400, origin = "1970-01-01", tz = "UTC")
  attr(out, "tzone") <- tz
  out
}

load_mat_timeseries <- function(path, time_var, value_var, tz = "America/New_York") {
  m <- R.matlab::readMat(path)
  
  # pull vectors (MATLAB often stores as matrix)
  t_raw <- as.vector(m[[time_var]])
  v_raw <- as.vector(m[[value_var]])
  
  # convert time: try datenum conversion first
  time <- matlab_datenum_to_posix(t_raw, tz = tz)
  
  tibble::tibble(time = time, value = v_raw) %>%
    dplyr::filter(!is.na(time), !is.na(value)) %>%
    dplyr::arrange(time)
}

load_mat_timeseries_1 <- function(path, time_var, value_var, tz = "America/New_York") {
  m <- R.matlab::readMat(path)
  
  # fail fast if names are wrong
  if (!time_var %in% names(m)) {
    stop("time_var not found: ", time_var,
         "\nAvailable: ", paste(names(m), collapse = ", "),
         "\nFile: ", path)
  }
  if (!value_var %in% names(m)) {
    stop("value_var not found: ", value_var,
         "\nAvailable: ", paste(names(m), collapse = ", "),
         "\nFile: ", path)
  }
  
  t_raw <- as.vector(m[[time_var]])
  v_raw <- as.vector(m[[value_var]])
  
  n <- min(length(t_raw), length(v_raw))
  time  <- matlab_datenum_to_posix(t_raw[seq_len(n)], tz = tz)
  value <- v_raw[seq_len(n)]
  
  tibble::tibble(time = time, value = value) %>%
    dplyr::filter(!is.na(time), !is.na(value)) %>%
    dplyr::arrange(time)
}

load_wind_csv <- function(path, tz = "America/New_York") {
  d <- readr::read_csv(path, show_col_types = FALSE)
  
  # Expect columns like Date_Time and wind_speed (based on your MATLAB)
  d %>%
    dplyr::mutate(
      time = as.POSIXct(Date_Time, tz = tz)  # if it’s already ISO w/ Z, this often “just works”
    ) %>%
    dplyr::transmute(time, value = wind_speed) %>%
    dplyr::filter(!is.na(time), !is.na(value)) %>%
    dplyr::arrange(time)
}


# MATLAB nansum(M, 1) = sum over rows, returning a 1 x T vector
# In R: colSums(M, na.rm = TRUE)
sum_across_depth <- function(M, target_len_time = NULL) {
  M <- as.matrix(M)
  
  cs <- as.vector(colSums(M, na.rm = TRUE))
  rs <- as.vector(rowSums(M, na.rm = TRUE))
  
  if (!is.null(target_len_time)) {
    if (length(cs) == target_len_time) return(cs)
    if (length(rs) == target_len_time) return(rs)
  }
  
  # fallback: choose the longer dimension as "time"
  # (usually time >> depth)
  if (ncol(M) >= nrow(M)) cs else rs
}

load_site_for_bottom_plot <- function(site_dir, tz = "America/New_York") {
  
  site_name   <- basename(site_dir)
  path_time   <- file.path(site_dir, "10min_time.mat")
  path_result <- file.path(site_dir, paste0(site_name, "_Results.mat"))
  
  m_time <- R.matlab::readMat(path_time)
  m_res  <- R.matlab::readMat(path_result)
  
  # ---- TIME ----
  time_raw <- m_time$time.10min.datenum
  if (is.null(time_raw)) {
    stop(
      "time.10min.datenum not found in: ", path_time,
      "\nAvailable variables: ", paste(names(m_time), collapse = ", ")
    )
  }
  time <- matlab_datenum_to_posix(time_raw, tz = tz)
  
  # ---- MATRICES ----
  sub_I_flux <- m_res$subtidal.I.SPM.flux
  tid_I_flux <- m_res$tidal.I.SPM.flux
  sub_O_flux <- m_res$subtidal.O.SPM.flux
  tid_O_flux <- m_res$tidal.O.SPM.flux
  
  tau_tidal    <- as.vector(m_res$tau.tidal)
  tau_subtidal <- as.vector(m_res$tau.subtidal)
  
  if (any(sapply(list(sub_I_flux, tid_I_flux, sub_O_flux, tid_O_flux), is.null))) {
    stop(
      "Missing one or more SPM flux matrices in: ", path_result,
      "\nAvailable variables: ", paste(names(m_res), collapse = ", ")
    )
  }
  if (is.null(tau_tidal) || is.null(tau_subtidal)) {
    stop(
      "tau_tidal or tau_subtidal missing in: ", path_result,
      "\nAvailable variables: ", paste(names(m_res), collapse = ", ")
    )
  }
  
  # ---- DERIVED ----
  net_I_flux <- sum_across_depth(sub_I_flux + tid_I_flux, target_len_time = length(time))
  net_O_flux <- sum_across_depth(sub_O_flux + tid_O_flux, target_len_time = length(time))
  net_SPM_flux <- net_I_flux + net_O_flux
  
  # ---- ALIGN ----
  n <- min(length(time), length(net_SPM_flux), length(tau_tidal), length(tau_subtidal))
  
  data.frame(
    time = time[seq_len(n)],
    net_depth_integrated_SPM_flux = net_SPM_flux[seq_len(n)],
    tau_tidal = tau_tidal[seq_len(n)],
    tau_subtidal = tau_subtidal[seq_len(n)],
    stringsAsFactors = FALSE
  )
}

tab_hydrodynamics_ui <- function(id = "hydro") {
  ns <- NS(id)
  
  tabPanel(
    title = "Hydrodynamics",
    value = "hydro",
    
    fluidPage(
      shinyjs::useShinyjs(),
      
      # ----------------------------
      # INTRO (no card)
      # ----------------------------
      div(
        class = "home-intro",
        
        # Row 1: header
        fluidRow(
          column(
            12,
            div(
              class = "hero-header",
              h1(
                "Hydrodynamic Conditions Driving Material Transport",
                class = "hero-title hero-title-overlay"
              )
            )
          )
        ),
        
        # Glossary Button 
        actionButton(
          inputId = ns("toggle_glossary"),
          label   = "Glossary",
          class   = "glossary-btn"
        ),
        
        # Glossary slide-out panel
        div(
          id = ns("glossary_tab"),
          class = "glossary-tab",
          h3("Glossary"),
          tags$hr(),
          tags$dl(
            # Acoustic Doppler Current Profiler (ADCP)
            tags$dt("Acoustic Doppler Current Profiler (ADCP)"),
            tags$dd("An instrument that measures water velocity and flow using sound waves, used to estimate sediment flux in the water."),
            
            # Acoustic Backscatter
            tags$dt("Acoustic Backscatter"),
            tags$dd("The reflection of sound waves from particles in the water, helping to measure sediment concentration."),
            
            # Bidirectional Transport
            tags$dt("Bidirectional Transport"),
            tags$dd("When sediment moves back and forth due to changes in tidal flow, moving both landward and seaward."),
            
            # Bioavailability
            tags$dt("Bioavailability"),
            tags$dd("How easily contaminants like mercury can be absorbed by organisms in the ecosystem."),
            
            # Critical Shear Stress
            tags$dt("Critical Shear Stress (τ₍c₎)"),
            tags$dd("The minimum amount of shear stress (τ₍c₎) required to move sediment particles from the bed of the estuary."),
            
            # Ebb Tide
            tags$dt("Ebb Tide"),
            tags$dd("The phase of the tide when water flows seaward, moving particles out of the estuary."),
            
            # Estuaries
            tags$dt("Estuaries"),
            tags$dd("Coastal areas where fresh water from rivers mixes with saltwater from the ocean, affected by tides."),
            
            # Flood Limit
            tags$dt("Flood Limit"),
            tags$dd("The point in the estuary where tidal waters no longer push upstream, marking the limit of tidal influence."),
            
            # Flood Tide
            tags$dt("Flood Tide"),
            tags$dd("The phase of the tide when water flows inland, moving sediment and contaminants toward the river."),
            
            # Grain Size / Median Grain Size (D₅₀)
            tags$dt("Grain Size / Median Grain Size (D₅₀)"),
            tags$dd("The particle size of sediment, important for understanding how easily it is moved by the tides."),
            
            # Landward vs Seaward Transport
            tags$dt("Landward vs Seaward Transport"),
            tags$dd("The movement of sediment towards the land (landward) or towards the ocean (seaward) depending on the tide."),
            
            # Material Retention
            tags$dt("Material Retention"),
            tags$dd("When sediment or contaminants are temporarily stored in one location before moving again."),
            
            # Mercury vs Methylmercury
            tags$dt("Mercury vs Methylmercury"),
            tags$dd("Mercury is a toxic element, while methylmercury is a more dangerous, bioaccumulating form that affects aquatic life."),
            
            # Net Transport
            tags$dt("Net Transport"),
            tags$dd("The overall direction in which sediment or material moves, considering both flood and ebb tides."),
            
            # River Discharge
            tags$dt("River Discharge"),
            tags$dd("The flow of water from the river into the estuary, affecting how material is transported."),
            
            # Sediment Bound Contaminants
            tags$dt("Sediment Bound Contaminants"),
            tags$dd("Pollutants like mercury that attach to sediment particles, influencing where and how they move in the water."),
            
            # Sediment Mobilization
            tags$dt("Sediment Mobilization"),
            tags$dd("When sediment particles are moved from the bed into the water column by shear stress from the flowing water."),
            
            # Shear Stress (τ)
            tags$dt("Shear Stress (τ)"),
            tags$dd("The force applied by flowing water that can move sediment or other particles on the estuary bed."),
            
            # Shields Parameter (θ)
            tags$dt("Shields Parameter (θ)"),
            tags$dd("A measure used to calculate the amount of shear stress (τ) needed to start moving sediment particles."),
            
            # Slack Tide
            tags$dt("Slack Tide"),
            tags$dd("The brief period when the water flow stops changing direction between flood and ebb tides."),
            
            # Subtidal
            tags$dt("Subtidal"),
            tags$dd("Flow that persists between tidal cycles, often driven by the river rather than the tides."),
            
            # Suspended Particulate Matter (SPM)
            tags$dt("Suspended Particulate Matter (SPM)"),
            tags$dd("Fine particles suspended in the water, including sediment and contaminants like mercury."),
            
            # SPM Flux
            tags$dt("SPM Flux"),
            tags$dd("The rate at which suspended particles move through the water column, helping to quantify sediment transport."),
            
            # Tidal Forcing
            tags$dt("Tidal Forcing"),
            tags$dd("The influence of the tides that causes the regular rise and fall of water levels, driving sediment movement."),
            
            # Tidal Reversals
            tags$dt("Tidal Reversals"),
            tags$dd("The switching of water flow directions due to changes in the tide, moving sediment both upstream and downstream."),
            
            # Water Level
            tags$dt("Water Level"),
            tags$dd("The height of the water surface, which varies with the tides and river discharge.")
          )
        ),
        
        # JS: toggle the 'open' class on click (module-safe)
        tags$script(
          HTML(sprintf(
            "
    (function() {
      function bindGlossaryToggle() {
        var btn = document.getElementById('%s');
        var panel = document.getElementById('%s');
        if (!btn || !panel) return;

        // Avoid double-binding if Shiny re-renders UI
        if (btn.dataset.bound === 'true') return;
        btn.dataset.bound = 'true';

        btn.addEventListener('click', function() {
          panel.classList.toggle('open');
        });
      }

      document.addEventListener('DOMContentLoaded', bindGlossaryToggle);

      // Re-bind after Shiny updates (important in modules / tabPanels)
      if (window.Shiny) {
        Shiny.addCustomMessageHandler('rebind_glossary', function(_) {
          bindGlossaryToggle();
        });
      }
      setTimeout(bindGlossaryToggle, 0);
    })();
    ",
            ns("toggle_glossary"),
            ns("glossary_tab")
          ))
        ),
        
        # Row 2: text + image
        fluidRow(
          column(
            6,
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
            h3("Overview", class = "tile-title", style = "text-align: center;"),
            p(
              "Estuaries are dynamic transition zones where river discharge and tidal forcing interact to control the movement, retention, and transformation of sediment-bound material. In the Penobscot River Estuary, a macrotidal system with a legacy mercury source, suspended particulate matter (SPM) plays a central role in transporting mercury and methylmercury. However, the mechanisms governing when and where material is mobilized or retained vary across space, time, and hydrodynamic regime.",
              style = "text-align: center;"
            ),
            p("This section synthesizes field observations collected during the deployment period from August to December 2023 to illustrate how material transport differs between two contrasting field sites within the estuary. Depth-integrated SPM fluxes were estimated using Acoustic Doppler Current Profilers (ADCPs), in situ water sampling, and calibrated acoustic backscatter, and were partitioned into tidal and subtidal components. At Bangor, which is typically upstream of the flood limit during high discharge, transport remains predominantly seaward and is strongly driven by river discharge. In contrast, Hampden exhibits transitional behavior, including shifts between ebb- and flood-dominated transport and episodic retention of organic-rich material. Together, these site-specific transport regimes influence where material accumulates or is exported, shaping patterns of contaminant retention and exposure risk within the system.",
              style = "text-align: center;"
              )
                )))
          ),
          column(
            6,
            div(
              class = "side-image-wrap",
              style = "margin-top: 20px;",
              tags$figure(
                class = "hero-figure",
                tags$img(
                  src = "Sediment_Transport.png",
                  alt = "Flood and ebb hydrodynamics animation",
                  style = "width:100%; height:auto; display:block;"
                ),
                tags$figcaption(
                  "Material transport patterns in the Penobscot Estuary.",
                  class = "hero-figure-caption"
                )
              )
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ----------------------------
      # MAP + LEFT OVERLAY
      # ----------------------------
      div(
        class = "hydro-map-wrap",
        
        leafletOutput(ns("hydro_map"), width = "100%", height = "650px"),
        
        div(
          class = "hydro-overlay-left",
          
          div(
            class = "overlay-section",
            h3("Penobscot River Estuary, ME", class = "tile-title"),
            p(
              "Material transport within the Penobscot River Estuary is shaped by the interaction between the tides, river, and wind. View local conditions below.",
              class = "helper-text"
            ),
            selectInput(
              ns("ts_driver"),
              "Display",
              choices = c(
                "Wind" = "wind",
                "Bangor Site Water Level" = "bangor_depth",
                "Hampden Site Water Level" = "hampden_depth",
                "West Enfield River Discharge" = "discharge"
              ),
              selected = "discharge"
            ),
            plotOutput(ns("plot_driver"), height = "180px")
          ),
          
          div(
            class = "overlay-section",
            h3("What the Map Shows", class = "tile-title"),
            p(
              "Use the layer controls to view reference field sites, historical and existing dams, and the primary legacy mercury point source within the estuary. These spatial layers provide geographic context for interpreting hydrodynamic conditions, sediment transport pathways, and the persistence of contamination within the Penobscot River system.",
              class = "helper-text"
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ----------------------------
      # Transport pies (transparent section)
      # ----------------------------
      div(
        class = "home-section-transparent",
        
        fluidRow(
          column(
            12,
            h3("Net Landward vs Seaward Transport by Location", class = "tile-title")
          )
        ),
        
        fluidRow(
          column(
            6,
            tags$div("Bangor, ME", class = "helper-text pie-site-label"),
            plotlyOutput(ns("pie_bangor_transport"), height = "350px")
          ),
          column(
            6,
            tags$div("Hampden, ME", class = "helper-text pie-site-label"),
            plotlyOutput(ns("pie_hampden_transport"), height = "350px")
          )
        ),
        
        fluidRow(
          column(
            12,
            tags$div(
              class = "hero-figure-caption",
              "Flood transport represents net landward movement; ebb transport represents net seaward movement of suspended particulate matter."
            )
          )
        )
      ),
      
      card(
        class = "tile-white tile-pop",
        card_body(
          
          # ---- Title row (centered) ----
          fluidRow(
            column(
              12,
              div(
              h3(
                "Net Direction of Suspended Sediment Transport Differs Strongly by Site",
                class = "tile-title",
                style = "font-weight: 700;"
              ))
            )
          ),
          
          # ---- Text body (left-aligned for readability) ----
          fluidRow(
            column(
              12,
              div(
                class = "how-to-text",
                
                p(
                  "Across the full deployment period, material transport exhibits a clear contrast between the two field sites, reflecting differences in the balance between tidal forcing and river discharge. At Bangor, transport is overwhelmingly seaward directed, with virtually no landward contribution. This pattern indicates strong river control on suspended particulate matter (SPM) movement and limited influence of tidal reversals, resulting in efficient downstream export of material from the upper estuary."
                ),
                
                p(
                  "At Hampden, transport remains predominantly seaward but includes a substantially larger landward component. Approximately 14% of total transport is directed landward, reflecting stronger tidal influence and more frequent flow reversals at this downstream site. This bidirectional behavior increases the potential for temporary material retention and redistribution before sediment is ultimately exported seaward."
                ),
                
                p(
                  "These patterns demonstrate how the balance between river discharge and tidal forcing governs whether SPM is rapidly exported or repeatedly reworked by tidal processes. These dynamics have important implications for the persistence and spatial distribution of sediment-associated contaminants, such as mercury and methylmercury, within the estuary."
                )
              )
            )
          )
        )
      ),
      
      div(class = "section-space"),

      # ----------------------------
      # Field site time series + interpretation
      # ----------------------------
      div(
        class = "home-section-transparent",
        
        h3("Field Site Conditions", class = "tile-title"),
        
        fluidRow(
          column(
            12,
            checkboxGroupInput(
              ns("bottom_series"),
              "Show",
              choices = c(
                "Net SPM flux (bars)" = "spm_flux",
                "Tidal shear stress (line)" = "tau_tidal",
                "Subtidal shear stress (line)" = "tau_subtidal"
              ),
              selected = c("spm_flux", "tau_tidal", "tau_subtidal"),
              inline = TRUE
            )
          )
        ),
        
        fluidRow(
          column(
            8,
            h4("Bangor Field Site", class = "tile-title"),
            plotlyOutput(ns("plot_site_bangor"), height = "260px", width = "100%"),
            verbatimTextOutput(ns("click_bangor")),
            
            div(class = "plot-stack-space"),
            
            h4("Hampden Field Site", class = "tile-title"),
            plotlyOutput(ns("plot_site_hampden"), height = "260px", width = "100%"),
            verbatimTextOutput(ns("click_hampden"))
          ),
          
          # Make this NOT a tile (no tile-white)
          column(
            4,
            div(
              class = "hydro-interpret-panel hydro-interpret-tile tile-pop",
              style = "
    background: rgba(240,240,240,0.82) !important;
    color:#0f1f2d !important;
    border-radius:16px !important;
    border:1px solid rgba(15,31,45,0.12) !important;
    padding:18px !important;
  ",
              
              div(
                h3(
                  "How to Interpret These Patterns",
                  class = "tile-title",
                  style = "font-weight: 700; color:#0f1f2d !important;"
                )),
              
              div(
                class = "hydro-interpret-body",
                style = "color:#0f1f2d !important;",
                
                p("These panels show depth-integrated suspended particulate matter (SPM) flux alongside tidal and subtidal shear stress at two field sites that occupy different positions relative to the flood limit, the upstream boundary where tidal flows reverse direction."),
                
                p("SPM flux represents the rate and direction of sediment transport through the water column, while shear stress describes the hydrodynamic force exerted by flowing water that governs sediment mobilization and settling. Tidal shear stress reflects the oscillatory influence of flood and ebb tides, whereas subtidal shear stress captures longer-duration, river-driven flow associated with discharge."),
                
                p("At the Bangor site, which lies upstream of the flood limit under most conditions, transport is dominated by subtidal processes linked to river discharge. Periods of elevated discharge strengthen subtidal shear stress and coincide with large, consistently seaward-directed SPM fluxes, indicating efficient downstream export of suspended material from the upper estuary."),
                
                p("In contrast, the Hampden site is situated closer to the flood limit and experiences stronger tidal influence. Here, tidal shear stress dominates the signal, resulting in greater variability in both the magnitude and direction of SPM flux. During high-discharge events, tidal and river forcing interact, producing large transport events but also increasing the potential for temporary material retention and redistribution within this reach."),
                
                p("These results show that sediment transport behavior shifts markedly over short spatial scales within the estuary. Upstream of the flood limit, transport is primarily unidirectional and controlled by river discharge, promoting efficient downstream export. In contrast, near the flood limit, interactions between tidal oscillations and river flow favor repeated mobilization, short-term storage, and reworking of suspended material. This behavior is critical for contaminant dynamics, because areas near the flood limit can act as zones of enhanced retention and recycling, increasing the likelihood that sediment-associated contaminants remain available for biological exposure rather than being rapidly exported.")
              )
            )
          )
        )
      ),
      
      # ----------------------------
      # TITLE for the section
      # ----------------------------
      div(
        class = "shear-framework",
        style = "text-align: center; margin-bottom: 20px; padding: 20px;",
        tags$h3("Shear Stress", class = "tile-title"),
        tags$p(
          "Shear stress thresholds were evaluated following the framework established by Wang (2012) and calculated using the Shields parameter:"
        ),
        withMathJax(
          tags$div(
            class = "equation-block",
            "$$ \\theta = \\frac{\\tau}{(\\rho_s - \\rho) g D_{50}} $$"
          )
        ),
        div(
          class = "equation-definitions",
          tags$p(
            HTML(
              "<b>Where:</b><br/>
                &theta; = Shields parameter (dimensionless)<br/>
                &tau; = shear stress (Pa)<br/>
                &rho;<sub>s</sub> = sediment density (≈ 2650 kg m<sup>−3</sup>)<br/>
                &rho; = water density (1000 kg m<sup>−3</sup>)<br/>
                g = gravitational acceleration (9.81 m s<sup>−2</sup>)<br/>
                D<sub>50</sub> = median grain diameter (m)"
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ----------------------------
      # Mobilization scatter (transparent section)
      # ----------------------------
      div(
        class = "home-section-transparent",
        
        fluidRow(
          column(
            12,
            h3("Sediment Mobilization as a Function of Shear Stress", class = "tile-title"),
            p("Interactive reconstruction of MATLAB outputs.", class = "helper-text")
          )
        ),
        
        fluidRow(
          column(
            6,
            tags$div("Bangor, ME", class = "helper-text pie-site-label"),
            plotlyOutput(ns("scatter_bangor_mob"), height = "520px")
          ),
          column(
            6,
            tags$div("Hampden, ME", class = "helper-text pie-site-label"),
            plotlyOutput(ns("scatter_hampden_mob"), height = "520px")
          )
        )
      ),
      
      card(
        class = "tile-white tile-pop",
        card_body(
          
          # ---- Title row (centered) ----
          fluidRow(
            column(
              12,
              div(
                h3(
                  "Interpreting Sediment Mobilization Results",
                  class = "tile-title",
                  style = "font-weight: 700;"
                ))
            )
          ),
          
          # ---- Text body (left-aligned for readability) ----
          fluidRow(
            column(
              12,
              div(
                class = "how-to-text",
                
                p(
                  "These scatter plots show how sediment mobilization varies with shear stress at each site, with points colored by whether sediment is mobilized during flood or ebb tides, or remains unmobilized. At Bangor, with coarser sediment (0.25 mm) and a higher critical shear stress (τ₍c₎ ≈ 0.182 Pa), mobilization primarily occurs during stronger, river-driven flow. Flood-phase mobilization is limited and occurs near slack tide when velocities approach zero but shear stress may still exceed the threshold. In contrast, Hampden’s finer sediment (0.063 mm) and lower critical shear stress (τ₍c₎ ≈ 0.153 Pa) allow mobilization across a wider range of conditions, with sediment being mobilized during both flood and ebb phases. This reflects stronger tidal influence near the flood limit, where sediment is more easily reworked."
                ),
                
                p(
                  "These patterns illustrate how grain size and shear stress thresholds interact with local hydrodynamics to control sediment mobilization, with coarser sediments at Bangor restricting mobilization to river-driven flow and finer sediments at Hampden enabling more frequent and phase-dependent mobilization. This helps explain why sediment is mobilized more often near the flood limit than farther upstream in the estuary."
                )
              )
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
    div(
      class = "home-section-transparent",
      
      fluidRow(
        column(
          12,
          h3("Net Material Transport Across Discharge Regimes", class = "tile-title"),
          p("Select a field site to compare net transport patterns across overall, low discharge, and high discharge conditions.", class = "helper-text")
        )
      ),
      
      fluidRow(
        # LEFT: controls + 3 vertical pies
        column(
          7,
          
          div(
            class = "overlay-section",  # or your preferred wrapper class
            selectInput(
              ns("site_pick"),
              "Field site",
              choices = c("Bangor, ME" = "bangor", "Hampden, ME" = "hampden"),
              selected = "bangor"
            )
          ),
          
          # 3 vertical pie charts
          div(
            class = "plot-stack",
            
            tags$div("Overall Net Transport", class = "helper-text pie-site-label"),
            plotlyOutput(ns("pie_net_overall"), height = "260px"),
            
            div(class = "plot-stack-space"),
            
            tags$div("Net During Low Discharge", class = "helper-text pie-site-label"),
            plotlyOutput(ns("pie_net_low"), height = "260px"),
            
            div(class = "plot-stack-space"),
            
            tags$div("Net During High Discharge", class = "helper-text pie-site-label"),
            plotlyOutput(ns("pie_net_high"), height = "260px")
          )
        ),
        
        # RIGHT: white tile explanation that swaps with site selection
        column(
          5,
          div(class = "section-space"),
          div(class = "section-space"),
          div(class = "section-space"),
          div(class = "section-space"),
          div(class = "section-space"),
          
          div(
            class = "hydro-interpret-panel tile-pop",  # (optional, keeps your naming consistent)
            style = "background: rgba(240,240,240,0.82) !important; color:#0f1f2d !important; border-radius:16px !important; border:1px solid rgba(15,31,45,0.12) !important; padding:18px !important;",
            
            div(
              class = "how-to-text",
              
              div(
                h3(
                  textOutput(ns("transport_tile_title")),
                  class = "tile-title",
                  style = "font-weight: 700; color:#0f1f2d !important;"
                )),
              
              div(
                style = "color:#0f1f2d !important;",
                uiOutput(ns("transport_tile_body"))
              )
            )
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          tags$div(
            class = "hero-figure-caption",
            "Each pie chart shows the proportion of net material transport occurring during flood and ebb tidal phases at each field site."
          )
        )
      )
    ),
    
    div(class = "section-space"),
    
    
      # ----------------------------
      # Mechanisms plots (side by side)
      # ----------------------------
      div(
        class = "home-section-transparent",
        
        fluidRow(
          column(
            12,
            h3("Explore Material Transport and River Discharge", class = "tile-title"),
          ),
          
          checkboxGroupInput(
            ns("mech_layers"),
            "Show",
            choices = c(
              "Subtidal transport" = "subtidal",
              "Flood-driven tidal transport" = "tidal_flood",
              "Ebb-driven tidal transport" = "tidal_ebb",
              "Net transport" = "net"
            ),
            selected = c("subtidal", "tidal_flood", "tidal_ebb", "net"),
            inline = TRUE
          ),
        ),
        
        fluidRow(
          column(6, tags$div("Bangor, ME", class = "helper-text pie-site-label"),
                 plotlyOutput(ns("mech_bangor"), height = "650px")),
          column(6, tags$div("Hampden, ME", class = "helper-text pie-site-label"),
                 plotlyOutput(ns("mech_hampden"), height = "650px"))
        )
      ),
    
    card(
      class = "tile-white tile-pop",
      card_body(
        fluidRow(
          div(
            h3(
              "Differences Between Transport of Organic and Inorganic Material",
              class = "tile-title",
              style = "font-weight: 700;"
            ))
        ),
        
        # ---- Text body (left-aligned for readability) ----
        fluidRow(
          column(
            12,
            div(
              class = "how-to-text",
              
              p(
                "These bar plots illustrate the differences in material transport between Bangor and Hampden under varying discharge conditions. At Bangor, net transport is overwhelmingly seaward, with inorganic material being transported more efficiently than organic material, particularly during low discharge. This suggests that inorganic material is primarily exported downstream, with minimal tidal influence. High discharge conditions enhance transport for both material types, but the dominant ebb-driven and subtidal contributions continue to export material from this upstream site."
              ),
              
              p(
                "In contrast, Hampden exhibits more balanced transport of organic and inorganic material, particularly during low discharge. The flood-driven component plays a larger role in transporting organic material, signaling greater tidal influence and the potential for material retention near the flood limit. Although inorganic material still follows a similar transport pattern as Bangor, the higher tidal influence at Hampden allows for more frequent redistribution of material, particularly during flood phases."
              ),
              
              p("Overall, while net transport remains seaward at both sites, Bangor shows a dominance of inorganic material, while Hampden has a more even balance of organic and inorganic material, especially when tidal forces are stronger. These differences are crucial for understanding the transport dynamics of sediment-bound contaminants, such as mercury and methylmercury, which are closely tied to fine particulate matter. At Bangor, inorganic material is more efficiently exported, minimizing the likelihood of mercury retention. However, at Hampden, the increased tidal influence may lead to temporary retention of mercury-bearing material, increasing bioavailability and exposure risk before eventual downstream export.")
            )
          )
        )
      )
    ),
    
    div(class = "section-space"),
    
    # ----------------------------
    # Key References
    # ----------------------------
    fluidRow(
      h3("Key References", class = "tile-title", style = "text-align: center;"),
      
      p(
        "The hydrodynamic and sediment transport concepts presented in this section draw from foundational estuarine theory, tidal sedimentology, and site-specific mercury investigations in the Penobscot River system. Key references informing the analytical framework and interpretation are listed below.",
        class = "helper-text"
      ),
      
      tags$ul(
        class = "helper-text reference-list",
        
        tags$li(
          "Aubrey, D. G., & Friedrichs, C. T. (1988). Seasonal climatology of tidal non-linearities in a shallow estuary. In D. G. Aubrey & L. Weishar (Eds.), ",
          tags$em("Hydrodynamics and sediment dynamics of tidal inlets"),
          " (pp. 103–124). Springer New York. ",
          tags$a(
            href = "https://doi.org/10.1007/978-1-4757-4057-8_6",
            "https://doi.org/10.1007/978-1-4757-4057-8_6",
            target = "_blank"
          )
        ),
        
        tags$li(
          "Bodaly, R. A., Rudd, J. W. M., Fisher, N. S., & Whipple, C. G. (2008). ",
          tags$em("Penobscot River Mercury Study: Phase I environmental study 2006–2007"),
          ". U.S. District Court. ",
          tags$a(
            href = "https://www.penobscotmercurystudy.com/__data/assets/pdf_file/0012/120234/382-document-phase-1-study-report-20080125.pdf",
            "Report PDF",
            target = "_blank"
          )
        ),
        
        tags$li(
          "Bodaly, R. A., & Kopec, A. D. (2013). ",
          tags$em("Penobscot River Mercury Study: Phase II environmental study"),
          ", Chapter 9: Upstream limit of mercury contamination in surface sediments. U.S. District Court."
        ),
        
        tags$li(
          "Parker, B. B. (Ed.). (1991). ",
          tags$em("Tidal hydrodynamics"),
          ". J. Wiley."
        ),
        
        tags$li(
          "Ralston, D. K., Geyer, W. R., Traykovski, P. A., & Nidzieko, N. J. (2013). Effects of estuarine and fluvial processes on sediment transport over deltaic tidal flats. ",
          tags$em("Continental Shelf Research"),
          ", 60, S40–S57. ",
          tags$a(
            href = "https://doi.org/10.1016/j.csr.2012.02.004",
            "https://doi.org/10.1016/j.csr.2012.02.004",
            target = "_blank"
          )
        ),
        
        tags$li(
          "Valle-Levinson, A. (2022). ",
          tags$em("Introduction to estuarine hydrodynamics"),
          " (1st ed.). Cambridge University Press. ",
          tags$a(
            href = "https://doi.org/10.1017/9781108974240",
            "https://doi.org/10.1017/9781108974240",
            target = "_blank"
          )
        ),
        
        tags$li(
          "Wang, P. (2012). Principles of sediment transport applicable in tidal environments. In ",
          tags$em("Principles of tidal sedimentology"),
          " (pp. 19–34). Springer Netherlands. ",
          tags$a(
            href = "https://doi.org/10.1007/978-94-007-0123-6_2",
            "https://doi.org/10.1007/978-94-007-0123-6_2",
            target = "_blank"
          )
        )
      )
    )
    )
  )
}


tab_hydrodynamics_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    # -----------------------------
    # Glossary Tab
    # -----------------------------
    
    # Toggle glossary tab visibility on button click
    observeEvent(input$toggle_glossary, {
      # Toggle the 'open' class to slide the glossary tab in and out
      shinyjs::toggleClass(id = ns("glossary_tab"), class = "open")
    })
    
    # -----------------------------
    # Load Bangor + Hampden once
    # -----------------------------
    bangor_df  <- load_site_for_bottom_plot("data/Bangor")
    hampden_df <- load_site_for_bottom_plot("data/Hampden")
    
    # -----------------------------
    # Pie charts 
    # -----------------------------
    make_transport_pie <- function(site_title, landward, seaward) {
      plotly::plot_ly(
        labels = c("Landward-Directed Transport", "Seaward-Directed Transport"),
        values = c(landward, seaward),
        type = "pie",
        marker = list(
          colors = c("#4CAF50", "#FF9800"),               # brighter for dark bg
          line = list(color = "rgba(255,255,255,0.35)", width = 1)
        ),
        textinfo = "label+percent",
        textposition = "outside",
        textfont = list(color = "#E6E6E6", size = 13),   # 🔑 light grey labels
        hoverinfo = "label+value+percent",
        sort = FALSE
      ) %>%
        plotly::layout(
          title = " ",
          
          font = list(color = "#E6E6E6"),                # 🔑 global text color
          showlegend = TRUE,
          
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.18,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)",
            bordercolor = "rgba(0,0,0,0)"
          ),
          
          margin = list(t = 60, b = 80, l = 40, r = 40),
          
          # fully transparent canvas
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) %>%
        plotly::config(displaylogo = FALSE)
    }
    
    output$pie_bangor_transport <- renderPlotly({
      make_transport_pie("Bangor, ME", landward = 0.05, seaward = 99.95)
    })
    
    output$pie_hampden_transport <- renderPlotly({
      make_transport_pie("Hampden, ME", landward = 14, seaward = 86)
    })
    
    # -----------------------------
    # Reference sites (map markers)
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
    
    site_icons <- awesomeIcons(
      icon = "map-pin", library = "fa",
      iconColor = "white",
      markerColor = c("green", "orange")
    )
    
    dam_icon <- awesomeIcons(
      icon = "water", library = "fa",
      iconColor = "white", markerColor = "gray"
    )
    
    pollution_icon <- awesomeIcons(
      icon = "industry", library = "fa",
      iconColor = "white", markerColor = "red"
    )
    
    # -----------------------------
    # Map
    # -----------------------------
    output$hydro_map <- renderLeaflet({
      leaflet() |>
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldTerrain, group = "Terrain") |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
        addLayersControl(
          baseGroups = c("Light", "Terrain", "Satellite"),
          overlayGroups = c("Reference Sites", "Dams", "Pollution Sources"),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        fitBounds(
          lng1 = min(c(sites$lng, dams$lng, pollution$lng)),
          lat1 = min(c(sites$lat, dams$lat, pollution$lat)),
          lng2 = max(c(sites$lng, dams$lng, pollution$lng)),
          lat2 = max(c(sites$lat, dams$lat, pollution$lat))
        ) |>
        addAwesomeMarkers(
          data = sites, lng = ~lng, lat = ~lat,
          icon = site_icons, label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>", role),
          group = "Reference Sites"
        ) |>
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
        )
    })
    
    # -----------------------------
    # Load driver datasets ONCE
    # -----------------------------
    driver_data <- reactiveVal(NULL)
    
    observeEvent(TRUE, {
      # ✅ adjust var names to match your .mat contents
      discharge_df <- load_mat_timeseries_1(
        path      = "data/Bangor/Dischargedata_datnum.mat",  # <- make sure this matches your real location
        time_var  = "Tdis.datenum",
        value_var = "Discharge",
        tz        = "America/New_York"
      )
      
      bangor_wl <- load_mat_timeseries_1(
        path = "data/Bangor/water_level.mat",
        time_var  = "time.10min.datenum",        # <--- change
        value_var = "depth.10min"  # <--- change
      )
      
      hampden_wl <- load_mat_timeseries_1(
        path = "data/Hampden/water_level.mat",
        time_var  = "time.10min.datenum",        # <--- change
        value_var = "depth.10min"  # <--- change
      )
      
      wind_df <- load_wind_csv("data/Bangor/KBGR_Data_Download.csv")
      
      driver_data(list(
        discharge     = discharge_df,
        bangor_depth  = bangor_wl,
        hampden_depth = hampden_wl,
        wind          = wind_df
      ))
    }, once = TRUE)
    
    # -----------------------------
    # Render map overlay plot
    # -----------------------------
    output$plot_driver <- renderPlot({
      req(input$ts_driver)
      dlist <- driver_data()
      req(!is.null(dlist))
      
      d <- dlist[[input$ts_driver]]
      req(nrow(d) > 1)
      
      title_map <- c(
        wind = "Local Wind speed (KBGR)",
        bangor_depth = "Bangor, ME",
        hampden_depth = "Hampden, ME",
        discharge = "West Enfield River Discharge"
      )
      
      y_map <- c(
        wind = "Wind speed (m/s)",
        bangor_depth = "Water level (m)",
        hampden_depth = "Water level (m)",
        discharge = "Discharge (m³/s)"
      )
      
      ggplot(d, aes(time, value)) +
        geom_line(linewidth = 0.7) +
        theme_minimal(base_size = 12) +
        theme(
          plot.background  = element_rect(fill = "transparent", color = NA),
          panel.background = element_rect(fill = "transparent", color = NA),
          axis.title.x = element_blank()
        ) +
        labs(
          title = title_map[[input$ts_driver]],
          y = y_map[[input$ts_driver]]
        )
    })
    
    # -----------------------------
    # Interactive Plotly outputs
    # -----------------------------
    make_site_plotly <- function(df, show, source_id) {
      
      y_flux <- max(abs(df$net_depth_integrated_SPM_flux), na.rm = TRUE)
      y_tau  <- max(abs(c(df$tau_tidal, df$tau_subtidal)), na.rm = TRUE)
      
      scale_factor <- if (is.finite(y_tau) && y_tau > 0) y_flux / y_tau else 1
      
      df$tau_tidal_scaled <- df$tau_tidal * scale_factor
      df$tau_sub_scaled   <- df$tau_subtidal * scale_factor
      
      p <- plotly::plot_ly(source = source_id)
      
      if ("spm_flux" %in% show) {
        p <- p |>
          plotly::add_bars(
            data = df,
            x = ~time,
            y = ~net_depth_integrated_SPM_flux,
            name = "Net SPM flux",
            marker = list(color = "#838B8B"),
            hovertemplate = "<b>Net SPM flux</b><br>%{x}<br>Value: %{y:.4f}<extra></extra>"
          )
      }
      
      if ("tau_tidal" %in% show) {
        p <- p |>
          plotly::add_lines(
            data = df,
            x = ~time,
            y = ~tau_tidal_scaled,
            name = "Tidal shear stress",
            line = list(color = "#f28e2b", width = 2),
            customdata = ~tau_tidal,
            hovertemplate = "<b>Tidal shear stress</b><br>%{x}<br>τ: %{customdata:.4f} Pa<extra></extra>"
          )
      }
      
      if ("tau_subtidal" %in% show) {
        p <- p |>
          plotly::add_lines(
            data = df,
            x = ~time,
            y = ~tau_sub_scaled,
            name = "Subtidal shear stress",
            line = list(color = "#59a14f", width = 2),
            customdata = ~tau_subtidal,
            hovertemplate = "<b>Subtidal shear stress</b><br>%{x}<br>τ: %{customdata:.4f} Pa<extra></extra>"
          )
      }
      
      p |>
        plotly::layout(
          hovermode = "x unified",
          barmode = "overlay",
          legend = list(orientation = "h"),
          xaxis = list(title = ""),
          yaxis = list(
            title = "SPM Flux (kg/m²/s)",
            range = c(-y_flux, y_flux)
          ),
          yaxis2 = list(
            title = "Shear Stress (Pa)",
            overlaying = "y",
            side = "right",
            range = c(-y_flux / scale_factor, y_flux / scale_factor)
          ),
          plot_bgcolor = "white",
          paper_bgcolor = "white"
        ) |>
        plotly::event_register("plotly_click") |>
        plotly::config(displaylogo = FALSE)
    }
    
    output$plot_site_bangor <- renderPlotly({
      req(input$bottom_series)
      make_site_plotly(bangor_df, input$bottom_series, "bangor")
    })
    
    output$plot_site_hampden <- renderPlotly({
      req(input$bottom_series)
      make_site_plotly(hampden_df, input$bottom_series, "hampden")
    })
    
    # -----------------------------
    # Click inspection (human-readable)
    # -----------------------------
    output$click_bangor <- renderPrint({
      d <- event_data("plotly_click", source = "bangor")
      if (is.null(d)) return("Click a bar or line to view values.")
      
      i <- d$pointNumber + 1
      
      if (is.na(i) || i < 1 || i > nrow(bangor_df)) {
        return("Clicked point is outside the available data range.")
      }
      
      data.frame(
        time = bangor_df$time[i],
        net_SPM_flux = bangor_df$net_depth_integrated_SPM_flux[i],
        tau_tidal = bangor_df$tau_tidal[i],
        tau_subtidal = bangor_df$tau_subtidal[i]
      )
    })
    
    output$click_hampden <- renderPrint({
      d <- event_data("plotly_click", source = "hampden")
      if (is.null(d)) return("Click a bar or line to view values.")
      
      i <- d$pointNumber + 1
      
      if (is.na(i) || i < 1 || i > nrow(hampden_df)) {
        return("Clicked point is outside the available data range.")
      }
      
      data.frame(
        time = hampden_df$time[i],
        net_SPM_flux = hampden_df$net_depth_integrated_SPM_flux[i],
        tau_tidal = hampden_df$tau_tidal[i],
        tau_subtidal = hampden_df$tau_subtidal[i]
      )
    })
    
    # -----------------------------
    # Load mobilization exports
    # -----------------------------
    bangor_mob  <- readr::read_csv("data/Bangor/mobilization_timeseries.csv",  show_col_types = FALSE)
    hampden_mob <- readr::read_csv("data/Hampden/mobilization_timeseries.csv", show_col_types = FALSE)
    
    required_cols <- c("tau", "U", "class", "tau_c")
    stopifnot(all(required_cols %in% names(bangor_mob)))
    stopifnot(all(required_cols %in% names(hampden_mob)))
    
    # -----------------------------
    # Plotly scatter builder
    # -----------------------------
    make_mobilization_scatter <- function(df, panel_title = " ", reverse_x = TRUE) {
      
      df <- df %>%
        dplyr::mutate(
          class = as.character(class)
        )
      
      # critical stress (scalar stored per row is fine)
      tau_c <- df$tau_c[which(!is.na(df$tau_c))[1]]
      
      # optional slack tide threshold if present
      has_slack <- "stress_threshold" %in% names(df)
      slack <- if (has_slack) df$stress_threshold[which(!is.na(df$stress_threshold))[1]] else NA_real_
      
      # enforce consistent legend ordering
      class_levels <- c("Mobilized flood", "Mobilized ebb", "Not mobilized")
      df$class <- factor(df$class, levels = class_levels)
      
      # ---- build shapes list for vertical lines ----
      shapes <- list(
        list(
          type = "line",
          x0 = 0, x1 = 0,
          y0 = 0, y1 = 1,
          xref = "x",
          yref = "paper",
          line = list(
            color = "rgba(255,255,255,0.75)",  # white / light grey
            dash  = "dash",
            width = 2
          )
        )
      )
      
      p <- plotly::plot_ly(
        data = df,
        x = ~tau,
        y = ~U,
        type = "scatter",
        mode = "markers",
        color = ~class,
        colors = c(
          "Mobilized flood" = "#2ca25f",
          "Mobilized ebb"   = "#fdae61",
          "Not mobilized"   = "#B0B0B0"
        ),
        marker = list(size = 6, opacity = 0.85),
        hovertemplate = paste(
          "<b>%{color}</b><br>",
          "Shear stress: %{x:.3f} Pa<br>",
          "Velocity: %{y:.3f} m/s<br>",
          "<extra></extra>"
        )
      ) %>%
        plotly::layout(
          title = "",
          
          font = list(color = "#E6E6E6"),     # 🔑 GLOBAL font color
          
          xaxis = list(
            title = list(
              text = "Shear stress (Pa)",
              font = list(color = "#E6E6E6")
            ),
            autorange = if (reverse_x) "reversed" else TRUE,
            zeroline = TRUE,
            zerolinecolor = "rgba(255,255,255,0.35)",
            gridcolor = "rgba(255,255,255,0.15)",
            tickfont = list(color = "#DADADA"),
            linecolor = "rgba(255,255,255,0.6)"
          ),
          
          yaxis = list(
            title = list(
              text = "Along-channel velocity (m/s)",
              font = list(color = "#E6E6E6")
            ),
            gridcolor = "rgba(255,255,255,0.15)",
            tickfont = list(color = "#DADADA"),
            linecolor = "rgba(255,255,255,0.6)"
          ),
          
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.2,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)"
          ),
          
          annotations = list(
            list(
              x = 0,
              y = 1.02,
              xref = "x",
              yref = "paper",
              text = "Slack Tide",
              showarrow = FALSE,
              font = list(color = "#E6E6E6", size = 12)
            )
          ),
          
          shapes = shapes,
          
          margin = list(t = 60, b = 90, l = 70, r = 30),
          
          # fully transparent canvas
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) %>%
        plotly::config(displaylogo = FALSE)
      
      return(p)
    }
    
    # -----------------------------
    # Outputs
    # -----------------------------
    output$scatter_bangor_mob <- renderPlotly({
      make_mobilization_scatter(bangor_mob, panel_title = "Bangor")
    })
    
    output$scatter_hampden_mob <- renderPlotly({
      make_mobilization_scatter(hampden_mob, panel_title = "Hampden")
    })
    
    # ---- condition lookup table (percent) ----
    condition_tbl <- data.frame(
      key = c("FloodLow","FloodHigh","EbbLow","EbbHigh","Flood","Ebb","Net"),
      label = c(
        "Flood Phase & Low Discharge",
        "Flood Phase & High Discharge",
        "Ebb Phase & Low Discharge",
        "Ebb Phase & High Discharge",
        "Net Flood Phase",
        "Net Ebb Phase ",
        "Net Overall"
      ),
      bangor_mob = c(0, 9, 89, 85, 15, 58, 73),
      bangor_not = c(100, 91, 11, 15, 85, 42, 27),
      hampden_mob = c(4, 5, 89, 86, 15, 53, 68),
      hampden_not = c(96, 95, 11, 14, 85, 47, 32),
      stringsAsFactors = FALSE
    )
    
    selected_row <- reactive({
      req(input$hydro_condition)
      condition_tbl[condition_tbl$key == input$hydro_condition, , drop = FALSE]
    })
    
    make_condition_pie <- function(site_name, mob, not_mob) {
      
      plotly::plot_ly(
        labels = c("Time mobilized", "Time not mobilized"),
        values = c(mob, not_mob),
        type = "pie",
        marker = list(
          colors = c("#4CAF50", "#FF9800"),   # brighter for dark bg
          line = list(color = "rgba(255,255,255,0.4)", width = 1)
        ),
        textinfo = "label+percent",
        textposition = "outside",
        textfont = list(color = "#E6E6E6", size = 13),  # 🔑 light grey labels
        hoverinfo = "label+value+percent",
        sort = FALSE
      ) %>%
        plotly::layout(
          title = list(
            text = site_name,
            x = 0.5,
            xanchor = "center",
            font = list(color = "#E6E6E6")
          ),
          
          font = list(color = "#E6E6E6"),  # 🔑 global font color
          
          showlegend = TRUE,
          
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.18,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)",
            bordercolor = "rgba(0,0,0,0)"
          ),
          
          margin = list(t = 60, b = 80, l = 40, r = 40),
          
          # 🔑 fully transparent canvas
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) %>%
        plotly::config(displaylogo = FALSE)
    }
    
    output$pie_bangor_condition <- renderPlotly({
      r <- selected_row()
      make_condition_pie(" ", r$bangor_mob, r$bangor_not)
    })
    
    output$pie_hampden_condition <- renderPlotly({
      r <- selected_row()
      make_condition_pie(" ", r$hampden_mob, r$hampden_not)
    })
    
    transport_tbl <- tibble::tibble(
      metric = c("Low", "High", "Net"),
      
      # Bangor
      bangor_flood = c(2,  36, 21),
      bangor_ebb   = c(98, 64, 79),
      
      # Hampden
      hampden_flood = c(26, 74, 22),
      hampden_ebb   = c(74, 26, 78)
    )
    
    site_data <- reactive({
      req(input$site_pick)
      input$site_pick
    })
    
    get_vals <- function(metric_key, site_key) {
      row <- transport_tbl %>% dplyr::filter(metric == metric_key)
      
      if (site_key == "bangor") {
        list(flood = row$bangor_flood[[1]], ebb = row$bangor_ebb[[1]])
      } else {
        list(flood = row$hampden_flood[[1]], ebb = row$hampden_ebb[[1]])
      }
    }
    
    # Reuse your existing pie builder but change labels to "Material transport" vs "No material transport"
    make_net_transport_pie <- function(flood_pct, ebb_pct) {
      plotly::plot_ly(
        labels = c("Flood Phase", "Ebb Phase"),
        values = c(flood_pct, ebb_pct),
        type = "pie",
        marker = list(
          colors = c("#4CAF50", "#FF9800"),
          line = list(color = "rgba(255,255,255,0.35)", width = 1)
        ),
        textinfo = "label+percent",
        textposition = "outside",
        textfont = list(color = "#E6E6E6", size = 12),
        hoverinfo = "label+value+percent",
        sort = FALSE
      ) %>%
        plotly::layout(
          title = " ",
          font = list(color = "#E6E6E6"),
          showlegend = TRUE,
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.18,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)",
            bordercolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 30, b = 60, l = 30, r = 30),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) %>%
        plotly::config(displaylogo = FALSE)
    }
    
    output$pie_net_overall <- renderPlotly({
      s <- site_data()
      v <- get_vals("Net", s)
      make_net_transport_pie(v$flood, v$ebb)
    })
    
    output$pie_net_low <- renderPlotly({
      s <- site_data()
      v <- get_vals("Low", s)
      make_net_transport_pie(v$flood, v$ebb)
    })
    
    output$pie_net_high <- renderPlotly({
      s <- site_data()
      v <- get_vals("High", s)
      make_net_transport_pie(v$flood, v$ebb)
    })
    
    # ---- Right tile title + body swap ----
    output$transport_tile_title <- renderText({
      if (site_data() == "bangor") "Field Site: Bangor, ME" else "Field Site: Hampden, ME"
    })
    
    output$transport_tile_body <- renderUI({
      if (site_data() == "bangor") {
        tagList(
          p(
            "When transport is aggregated across the full deployment period, Bangor exhibits strong and persistent ebb dominance, with approximately 79% of material transport occurring during ebb tides and only 21% during flood tides. This net pattern reflects Bangor’s position near the upstream boundary of the flood limit, where river discharge consistently drives transport seaward and limits the influence of tidal reversals on long-term sediment accumulation."
          ),
          p(
            "During low discharge conditions, transport at Bangor occurs almost entirely during ebb tides. Approximately 98% of material transport is associated with ebb phases, while flood tides contribute only about 2%. Under these conditions, river-driven subtidal flow dominates, resulting in efficient downstream export of suspended particulate matter with minimal opportunity for tidal retention."
          ),
          p(
            "During high discharge conditions, ebb dominance persists, but flood-phase contributions increase modestly. Flood tides account for approximately 36% of transport, while ebb tides contribute about 64%. This pattern reflects episodic tidal influence during elevated flows; however, the net direction of transport remains strongly seaward, indicating limited capacity for sustained landward redistribution."
          ),
          p(
            "Because mercury and methylmercury are primarily transported while bound to fine suspended particulate matter, these transport dynamics have direct implications for contaminant exposure. At Bangor, the dominance of ebb-directed transport across both discharge regimes promotes rapid downstream export of contaminated particles, reducing the likelihood of prolonged sediment retention or upstream redistribution within the upper estuary. As a result, exposure pathways at this site are more closely associated with short-term suspension and downstream transport rather than local accumulation."
          ),
          p(
            tags$b("How to read the three charts:"), 
            "The top pie chart shows overall transport contributions by tidal phase across the full deployment. The middle and bottom pie charts isolate transport during low- and high-discharge conditions, illustrating how increased river flow allows limited tidal influence without reversing the dominant seaward transport pathway at this upstream site."
          )
        )
      } else {
        tagList(
          p(
            "When transport is aggregated across the full deployment period, Hampden shows a clear but not exclusive ebb dominance, with approximately 78% of material transport occurring during ebb tides and 22% during flood tides. This net pattern indicates that, despite frequent tidal reversals, river discharge exerts a persistent seaward bias on material transport at this site, limiting the long-term accumulation of sediment upstream."
          ),
          p(
            "During low discharge conditions, transport at Hampden is dominated by ebb tides at 74%. Flood tides account for approximately 26% of transport. Under these conditions, there is some potential for short-term retention and bidirectional redistribution of material upstream of the flood limit."
          ),
          p(
            "During high discharge conditions, flood-phase contributions increase substantially, with flood tides accounting for approximately 74% of transport and ebb tides contributing about 26%. This reflects intensified tidal–river interaction, where elevated flows shift the flood limit and enhance tidal energy at the site. Material transport becomes strongly bidirectional during these periods."
          ),
          p(
            "Because mercury and methylmercury are strongly associated with fine SPM, these transport patterns have direct implications for contaminant exposure and retention in the system. At Hampden, periods of bidirectional transport, particularly during low and high discharge conditions when flood-phase contributions increase, create repeated opportunities for contaminated particles to be mobilized, redistributed, and temporarily retained near the flood limit. Although net transport remains predominantly seaward, this oscillatory behavior can prolong the residence time of mercury-bearing sediments, increasing the likelihood of exposure for biological organisms and uptake into food webs before material is ultimately exported downstream."
          ),
          p(
            tags$b("How to read the three charts:"), 
            "The top pie chart shows overall transport contributions by tidal phase across the full deployment. The middle and bottom pie charts isolate transport during low- and high-discharge conditions, illustrating how proximity to the flood limit allows both flood and ebb tides to mobilize sediment while river discharge ultimately controls the net direction of transport."
          )
        )
      }
    })
    
# Bar plot for Transport and Discharge Conditions
    # Bar plot for Transport and Discharge Conditions
    make_mechanisms_plot <- function(low_df, high_df, site_title = "Bangor, ME", layers) {
      
      prep <- function(df, regime_name) {
        df %>%
          dplyr::mutate(
            regime = regime_name,
            net_flux = tidal_flux + subtidal_flux
          )
      }
      
      df <- dplyr::bind_rows(
        prep(low_df,  "Low discharge"),
        prep(high_df, "High discharge")
      )
      
      x_labels <- df %>%
        dplyr::distinct(x, label) %>%
        dplyr::arrange(x)
      
      ax_color   <- "#D0D0D0"
      grid_color <- "rgba(255,255,255,0.12)"
      
      build_panel <- function(regime_name, show_legend = FALSE) {
        
        d <- df %>% dplyr::filter(regime == regime_name)
        d_flood <- d %>% dplyr::filter(x <= 3)
        d_ebb   <- d %>% dplyr::filter(x >= 4)
        
        p <- plotly::plot_ly()
        
        # SUBTIDAL
        if ("subtidal" %in% layers) {
          p <- p %>% plotly::add_bars(
            data = d, x = ~x, y = ~subtidal_flux,
            name = "Subtidal transport",
            legendgroup = "subtidal",
            showlegend = show_legend,
            marker = list(color = "#BEBEBE", line = list(width = 0)),
            width = 0.70,
            hovertemplate = "<b>%{customdata}</b><br>Subtidal: %{y:.2f}<extra></extra>",
            customdata = ~label
          )
        }
        
        # TIDAL FLOOD
        if ("tidal_flood" %in% layers) {
          p <- p %>% plotly::add_bars(
            data = d_flood, x = ~x, y = ~tidal_flux,
            name = "Flood-driven tidal transport",
            legendgroup = "tidal_flood",
            showlegend = show_legend,
            marker = list(color = "#2ca25f", line = list(width = 0)),
            width = 0.70,
            hovertemplate = "<b>%{customdata}</b><br>Tidal: %{y:.2f}<extra></extra>",
            customdata = ~label
          )
        }
        
        # TIDAL EBB
        if ("tidal_ebb" %in% layers) {
          p <- p %>% plotly::add_bars(
            data = d_ebb, x = ~x, y = ~tidal_flux,
            name = "Ebb-driven tidal transport",
            legendgroup = "tidal_ebb",
            showlegend = show_legend,
            marker = list(color = "#fdae61", line = list(width = 0)),
            width = 0.70,
            hovertemplate = "<b>%{customdata}</b><br>Tidal: %{y:.2f}<extra></extra>",
            customdata = ~label
          )
        }
        
        # NET bars
        if ("net" %in% layers) {
          p <- p %>% plotly::add_bars(
            data = d, x = ~x, y = ~net_flux,
            name = "Net transport",
            legendgroup = "net",
            showlegend = show_legend,
            marker = list(color = "#4D4D4D", line = list(width = 0)),
            width = 0.25,
            hovertemplate = "<b>%{customdata}</b><br>Net: %{y:.2f}<extra></extra>",
            customdata = ~label
          )
          
          # # ✅ Net value labels: first 3 black
          # d_left  <- d %>% dplyr::filter(x <= 3)
          # p <- p %>% plotly::add_text(
          #   data = d_left,
          #   x = ~x,
          #   y = ~net_flux + 0.7 * sign(net_flux),
          #   text = ~sprintf("%.2f", net_flux),
          #   textfont = list(color = "#000000", size = 13),
          #   showlegend = FALSE,
          #   hoverinfo = "skip"
          # )
          
          # # ✅ Net value labels: next 3 white
          # d_right <- d %>% dplyr::filter(x >= 4)
          # p <- p %>% plotly::add_text(
          #   data = d_right,
          #   x = ~x,
          #   y = ~net_flux + 0.7 * sign(net_flux),
          #   text = ~sprintf("%.2f", net_flux),
          #   textfont = list(color = "#E6E6E6", size = 13),
          #   showlegend = FALSE,
          #   hoverinfo = "skip"
          # )
        }
        
        p %>% plotly::layout(
          barmode = "overlay",
          
          xaxis = list(
            tickmode = "array",
            tickvals = x_labels$x,
            ticktext = x_labels$label,
            tickangle = 20,
            tickfont = list(color = ax_color, size = 12),
            gridcolor = grid_color,
            zerolinecolor = "rgba(255,255,255,0.25)",
            range = c(0.5, 6.5)
          ),
          
          yaxis = list(
            title = "Mean SPM Flux (kg/m²/s)",
            range = c(-16, 4),
            color = ax_color,
            gridcolor = grid_color,
            zerolinecolor = "rgba(255,255,255,0.25)"
          ),
          
          shapes = list(
            list(
              type = "line",
              x0 = 3.5, x1 = 3.5,
              y0 = -16, y1 = 4,
              line = list(color = "rgba(255,255,255,0.45)", width = 1.2, dash = "dash")
            )
          ),
          
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.18,
            font = list(color = ax_color),
            bgcolor = "rgba(0,0,0,0)"
          ),
          
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        )
      }
      
      p_low  <- build_panel("Low discharge",  show_legend = TRUE)
      p_high <- build_panel("High discharge", show_legend = FALSE)
      
      plotly::subplot(p_low, p_high, nrows = 2, shareX = TRUE, titleX = FALSE, titleY = TRUE,   margin = 0.08   # ✅ controls vertical gap between panels
) %>%
        plotly::layout(
          title = list(
            text = paste0("<b>", site_title, "</b>"),
            x = 0.5, xanchor = "center",
            font = list(color = ax_color)
          ),
          
          annotations = list(
            list(
              text = "<b>Low Discharge Conditions</b>",
              x = 0, xanchor = "left",
              y = 1.02, yanchor = "bottom",
              xref = "paper", yref = "paper",
              showarrow = FALSE,
              font = list(color = ax_color, size = 18)
            ),
            list(
              text = "<b>High Discharge Conditions</b>",
              x = 0, xanchor = "left",
              y = 0.46, yanchor = "bottom",
              xref = "paper", yref = "paper",
              showarrow = FALSE,
              font = list(color = ax_color, size = 18)
            )
          ),
          
          # ✅ give space for row titles + legend
          margin = list(t = 90, b = 110, l = 70, r = 30),
          
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) %>%
        plotly::config(displaylogo = FALSE)
    }
    

# read the exported mechanism summaries
    bangor_low  <- readr::read_csv("data/Bangor/mechanisms_lowQ.csv",  show_col_types = FALSE)
    bangor_high <- readr::read_csv("data/Bangor/mechanisms_highQ.csv", show_col_types = FALSE)
    
    hampden_low  <- readr::read_csv("data/Hampden/mechanisms_lowQ.csv",  show_col_types = FALSE)
    hampden_high <- readr::read_csv("data/Hampden/mechanisms_highQ.csv", show_col_types = FALSE)
    
    output$mech_bangor <- renderPlotly({
      req(input$mech_layers)
      make_mechanisms_plot(bangor_low, bangor_high, " ", layers = input$mech_layers)
    })
    
    output$mech_hampden <- renderPlotly({
      req(input$mech_layers)
      make_mechanisms_plot(hampden_low, hampden_high, " ", layers = input$mech_layers)
    })
    
  })
}