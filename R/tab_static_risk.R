# ============================
# UI
# ============================
tab_static_risk_ui <- function(id = "static") {
  ns <- NS(id)
  
  tabPanel(
    title = "Life Stage Risk",
    value = "static",
    
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
                "Habitat Availability as a Driver of Contaminant Exposure",
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
            
            tags$dt("Anadromous"),
            tags$dd("Fish that migrate from the ocean into freshwater systems to spawn."),
            
            tags$dt("River herring"),
            tags$dd("A group of migratory fish species, including alewife, that use the Penobscot River Estuary during their life cycle."),
            
            tags$dt("Alewife"),
            tags$dd("A species of river herring that migrates seasonally through the Penobscot River Estuary to spawn in freshwater."),
            
            tags$dt("Life stage"),
            tags$dd("A distinct phase in an organism's life cycle, such as adult, egg and larva, or juvenile, each with different habitat use and exposure pathways."),
            
            tags$dt("Estuary"),
            tags$dd("A transition zone where freshwater from rivers mixes with saltwater from the ocean, creating dynamic physical and chemical conditions."),
            
            tags$dt("Hydrodynamics"),
            tags$dd("The movement and behavior of water within the estuary, including tides, river flow, and circulation patterns that influence material transport."),
            
            tags$dt("Hydrodynamic model"),
            tags$dd("A numerical model used to simulate water movement and environmental conditions, including depth, velocity, salinity, and temperature, through time and space."),
            
            tags$dt("Delft3D"),
            tags$dd("A three-dimensional hydrodynamic modeling framework used to simulate estuarine circulation, sediment transport, and water quality in the Penobscot River Estuary."),
            
            tags$dt("Material transport"),
            tags$dd("The movement of sediment and associated substances through the estuary by flowing water."),
            
            tags$dt("Sediment-associated contamination"),
            tags$dd("Contaminants, such as mercury, that are attached to sediment particles rather than dissolved in water."),
            
            tags$dt("Methylmercury (MeHg)"),
            tags$dd("An organic form of mercury that readily enters food webs and bioaccumulates in fish tissue."),
            
            tags$dt("Bioaccumulation"),
            tags$dd("The process by which contaminants build up in organisms over time through repeated exposure."),
            
            tags$dt("Habitat suitability"),
            tags$dd("A measure of how favorable environmental conditions are for supporting a particular species or life stage."),
            
            tags$dt("Habitat Suitability Index (HSI)"),
            tags$dd("A numerical index ranging from 0 to 1 that quantifies habitat quality based on environmental variables such as depth, temperature, salinity, and velocity."),
            
            tags$dt("Depth"),
            tags$dd("Water depth, used as a proxy for habitat availability and suitability across different life stages."),
            
            tags$dt("Velocity"),
            tags$dd("Water flow speed, influencing fish movement, energetic cost, and sediment transport."),
            
            tags$dt("Salinity"),
            tags$dd("The concentration of dissolved salts in water, reflecting the mixing of freshwater and seawater within the estuary."),
            
            tags$dt("Temperature"),
            tags$dd("Water temperature, a key environmental variable influencing metabolism, development, and habitat suitability."),
            
            tags$dt("High-quality habitat"),
            tags$dd("Areas with high habitat suitability where organisms are most likely to occur and persist."),
            
            tags$dt("Exposure pathway"),
            tags$dd("The route through which organisms encounter contaminants, shaped by behavior, habitat use, and environmental transport processes."),
            
            tags$dt("Contamination risk"),
            tags$dd("The likelihood that organisms encounter, uptake, and are affected by contaminants due to the overlap of suitable habitat and contaminated areas."),
            
            tags$dt("Normalized concentration"),
            tags$dd("A rescaled contaminant value that allows concentrations to be compared relative to biological effect thresholds."),
            
            tags$dt("Biological impairment"),
            tags$dd("A reduction in organism health or function caused by contaminant exposure."),
            
            tags$dt("Habitat impact"),
            tags$dd("A metric describing where biologically suitable habitat overlaps with elevated contaminant concentrations."),
            
            tags$dt("Habitat impairment"),
            tags$dd("A metric describing the reduction in functional habitat quality due to the probability of contaminant-driven biological effects."),
            
            tags$dt("Ecotoxicological thresholds"),
            tags$dd("Concentration benchmarks used to relate contaminant levels to expected biological effects."),
            
            tags$dt("ERL (Effects Range Low)"),
            tags$dd("A sediment concentration below which adverse biological effects are rarely observed."),
            
            tags$dt("ERM (Effects Range Median)"),
            tags$dd("A sediment concentration above which adverse biological effects are frequently observed."),
            
            tags$dt("Cumulative contamination risk"),
            tags$dd("The buildup of exposure and impairment over time as organisms repeatedly occupy contaminated habitat."),
            
            tags$dt("Persistent risk hotspot"),
            tags$dd("A spatial area where elevated contamination risk consistently overlaps with habitat used by multiple life stages.")
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
        
        # ----------------------------
        # Intro Section
        # ----------------------------     
        fluidRow(
          column(
            width = 10,
            offset = 1,
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
                  h3("Overview", class = "tile-title", style = "text-align: center;"),
                  p("River herring are migratory fish native to the Penobscot River Estuary that spend their adult lives at sea and migrate into freshwater reaches each spring to spawn. As broadcast spawners, their eggs and larvae have limited mobility and are largely transported by estuarine hydrodynamics, while juveniles subsequently occupy more brackish habitats before out-migration. These life-history transitions create distinct, life-stage-specific exposure pathways to contaminants that are strongly influenced by the timing of migration, habitat availability, and sediment-associated mercury within the estuary.",
                    style = "text-align: center;"
                  ),
                  p("This section evaluates contamination risk across anadromous life stages by integrating habitat suitability modeling with spatially explicit methylmercury data and hydrodynamic output from a three-dimensional Delft3D model of the Penobscot River Estuary. The model was calibrated and validated using field observations described on the previous page and simulates estuarine conditions from April through October, encompassing the migration and rearing season for native river herring. By linking modeled hydrodynamics, biologically suitable habitat, and contaminant distributions, this analysis identifies where river herring could be more likely to encounter elevated contamination risk based on modeled habitat suitability and contaminant distributions across the estuary.",
                    style = "text-align: center;"
                  )
                )))
          )),
        
        # ----------------------------
        # River herring Section
        # ----------------------------     
        div(class = "section-space"),
        
        fluidRow(
          
          column(
            5,
            h3("River Herring in the Penobscot River Estuary", class = "tile-title", style = "text-align: center;"),
            div(class = "section-space-small"),
            p(
              "River herring presence in the Penobscot River Estuary is strongly seasonal, reflecting the timing of upstream migration, spawning, and downstream movement through the system. Alewife are typically observed entering the estuary in early spring, with passage occurring from April through October and peaking during late spring. The timing and magnitude of this movement vary within and among years, shaping when different portions of the estuary are actively occupied by migrating and rearing fish.",
              class = "helper-text"
            ),
            p(
              "River herring abundance within the system is routinely documented using fish passage counts at dams, culverts, and tributaries. The visualization shown here summarizes alewife passage at the Milford Dam fish lift during the 2023 season, providing an empirical record of migration timing and intensity. These observations establish the seasonal window over which suitable habitat and hydrodynamic conditions are biologically relevant, and they provide context for interpreting the seasonal patterns in habitat availability and contamination risk presented in the following section.",
              class = "helper-text"
            )
          ),
          column(
            7,
            plotlyOutput(ns("ridge_int"), height = "400px")
            
          ),
        ),
        
        # ----------------------------
        # Habitat 
        # ----------------------------
        div(class = "section-space"),
        
        fluidRow(
          column(
            8,
            div(
              class = "side-image-wrap",
              style = "margin-top: 50px; display: flex; align-items: center; height: 100%;",
              tags$figure(
                class = "hero-figure",
                plotly::plotlyOutput(ns("hq_area_plot"), height = "750px", width = "100%"),
                tags$figcaption(
                  "Seasonal high-quality habitat area (HSI > 0.8) by life stage in the Penobscot River Estuary, April\u2013October 2023. Each panel has an independent y-axis to show life-stage-specific patterns. No grid cells met the habitat suitability criteria for eggs and larvae under the model formulation used here.",
                  class = "hero-figure-caption"
                )
              )
            )
          ),
          column(
            4,
            style = "margin-top: 40px;",
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
                  h3("Seasonality in River Herring Habitat", class = "tile-title", style = "text-align: center;"),
                  div(class = "section-space-small"),
                  
                  p(
                    "Habitat availability for alewife within the Penobscot River Estuary changes through the migration and rearing season and differs among life stages. Modeled adult habitat suitability is minimal through spring and early summer, increasing sharply in late summer with a pronounced peak in August (approximately 145 km\u00b2), followed by a decline in September. In contrast, habitat availability for eggs and larvae is effectively absent across all months, with no grid cells meeting the full set of suitability criteria under the zero-limiting formulation used here. Juvenile habitat shows the largest total area and strong seasonality, with suitable habitat expanding from late spring and peaking in July and August (approximately 6,400\u20136,600 km\u00b2) before declining into autumn.",
                    class = "helper-text"
                  ),
                  p(
                    "These seasonal patterns reflect differences in how each life stage interacts with estuarine conditions. Adults move through the system during much of the year and are less constrained by short-term changes in temperature, salinity, and flow. Eggs and larvae are present for a shorter, more focused window that coincides with peak spawning activity, while juveniles occupy the estuary for a longer period but experience progressive changes in habitat availability as the system transitions from spring to fall. As a result, each life stage is predicted to have access to suitable habitat at different times and in different parts of the estuary.",
                    class = "helper-text"
                  ),
                  p(
                    "Because contamination risk arises where suitable habitat overlaps with contaminated areas, seasonal changes in habitat availability directly influence exposure potential. Periods when habitat expands increase opportunities for contact with contaminated sediment and suspended material, while seasonal contractions can concentrate individuals into fewer areas, potentially intensifying exposure. These shifting patterns mean that contamination risk is not constant through time, but varies seasonally and differently across life stages.",
                    class = "helper-text"
                  ))))
          ),
        ),
        
        div(class = "section-space"),
        
        # NOAA Water Quality Guidelines
        fluidRow(
          column(
            12,
            h3(
              "Water Quality Guidelines for Biological Impairment",
              class = "tile-title",
              style = "text-align: center;"
            )
          ),
          
          div(class = "section-space-small"),
          
          column(
            12,
            
            div(
              class = "tile-white tile-pop",
              style = "max-width: 980px; margin: 0 auto 32px auto;",
              
              tags$table(
                class = "table table-striped table-bordered",
                style = "width: 100%; margin-bottom: 12px;",
                
                tags$thead(
                  tags$tr(
                    tags$th("MeHg Concentration Range (ng/g)"),
                    tags$th("Threshold Category"),
                    tags$th("Normalized Value"),
                    tags$th("Assigned Incidence Rate (%)"),
                    tags$th("Interpretation")
                  )
                ),
                
                tags$tbody(
                  tags$tr(
                    tags$td("< 15"),
                    tags$td("Below ERL"),
                    tags$td("0"),
                    tags$td("8.30"),
                    tags$td("Negligible biological effect")
                  ),
                  tags$tr(
                    tags$td("15\u201371"),
                    tags$td("Between ERL and ERM"),
                    tags$td("Linearly scaled between 0 and 1"),
                    tags$td("23.5"),
                    tags$td("Increasing probability of biological effects")
                  ),
                  tags$tr(
                    tags$td("\u2265 71"),
                    tags$td("Above ERM"),
                    tags$td("1"),
                    tags$td("42.3"),
                    tags$td("High likelihood of adverse biological effects")
                  )
                )
              ),
              
              tags$div(
                class = "hero-figure-caption",
                style = "text-align: center; margin-top: 8px; color: #0f1f2d;",
                HTML(
                  "<b>Table 1.</b> Ecotoxicological threshold categories used to normalize methylmercury (MeHg) sediment concentrations and estimate biological effect probability in the Penobscot River Estuary. Thresholds are based on NOAA Guidelines for Sediment Quality. Threshold values: ERL = 15 ng g\u207b\u00b9; ERM = 71 ng g\u207b\u00b9."
                )
              )
            )
          ),
          
          column(
            width = 10,
            offset = 1,
            p(
              "Biological impairment in the Penobscot River Estuary is evaluated using methylmercury (MeHg), the organic form of mercury that is most readily taken up by organisms and transferred through aquatic food webs. Methylmercury bioaccumulates in fish tissue and is strongly associated with adverse neurological effects, particularly for developing fetuses and children. Because of these risks, fish consumption advisories have remained in effect across much of the Penobscot River watershed since 1987. Current guidance recommends that children and women who are pregnant, breastfeeding, or may become pregnant avoid consumption of anadromous fish from the Penobscot River, while other adults limit consumption to no more than one meal per month.",
              style = "text-align: center;"
            ),
            p(
              "To interpret spatial patterns of methylmercury within the estuary in a biologically meaningful way, sediment concentrations are evaluated relative to established ecotoxicological benchmarks. The table below summarizes threshold categories used to classify methylmercury concentrations in sediment based on NOAA sediment quality guidelines. These thresholds define ranges associated with negligible, increasing, and high likelihoods of adverse biological effects, and they provide the basis for normalizing methylmercury concentrations and estimating the probability of biological impairment across the system.",
              style = "text-align: center;"
            )
          )
        ),
        
        div(class = "section-space-small"),
        
        # ----------------------------
        # Life-Stage-Specific Suitability Indices
        # ----------------------------        
        fluidRow(
          h3(
            "Identifying River Herring Habitat",
            class = "tile-title",
            style = "text-align: center;"
          ),
          div(class = "section-space-small"),
          
          column(
            12,
            
            card(
              class = "tile-white tile-pop",
              
              card_body(
                
                div(
                  id = ns("life_stage_tabs_wrap"),
                  
                  tags$style(HTML(sprintf("
            #%s .nav-tabs .nav-link,
            #%s .nav-tabs .nav-link:hover,
            #%s .nav-tabs .nav-link:focus {
              color: #000000 !important;
            }

            #%s .nav-tabs .nav-link.active,
            #%s .nav-tabs .nav-item.show .nav-link {
              color: #000000 !important;
              font-weight: 700 !important;
            }
          ",
                                          ns("life_stage_tabs_wrap"),
                                          ns("life_stage_tabs_wrap"),
                                          ns("life_stage_tabs_wrap"),
                                          ns("life_stage_tabs_wrap"),
                                          ns("life_stage_tabs_wrap")
                  ))),
                  
                  tabsetPanel(
                    id = ns("life_stage_tabs"),
                    type = "tabs",
                    
                    tabPanel(
                      title = "Adults",
                      
                      div(
                        style = "display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;",
                        plotlyOutput(ns("adult_depth_plot"), height = "200px"),
                        plotlyOutput(ns("adult_temp_plot"),  height = "200px"),
                        plotlyOutput(ns("adult_sal_plot"),   height = "200px"),
                        plotlyOutput(ns("adult_vel_plot"),   height = "200px")
                      ),
                      
                      div(
                        h3(
                          "Adult Suitability Indices",
                          class = "tile-title",
                          style = "font-weight: 700; color:#0f1f2d !important;"
                        )
                      ),
                      
                      p(
                        "Three-dimensional hydrodynamic outputs from Delft3D were parsed by month and vertically averaged to generate spatial fields of depth, velocity, temperature, and salinity across the estuary. These environmental conditions were converted to raster format and evaluated using life-stage-specific suitability functions scaled from 0 (unsuitable) to 1 (optimal). For adults, suitability reflects broader tolerances across estuarine conditions, with preference for shallow depths, low velocities, moderate temperatures, and low to moderate salinity. Habitat suitability was calculated for each grid cell (0.038 km²) as the geometric mean across variables, ensuring that unsuitable conditions in any single dimension constrain overall habitat quality. Resulting suitability surfaces were integrated with contaminant exposure data to evaluate spatial and temporal patterns of habitat-dependent contamination risk.",
                        class = "helper-text"
                      )
                      
                    ),
                    
                    tabPanel(
                      title = "Eggs and Larvae",
                      
                      div(
                        style = "display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;",
                        plotlyOutput(ns("eggs_depth_plot"), height = "200px"),
                        plotlyOutput(ns("eggs_temp_plot"),  height = "200px"),
                        plotlyOutput(ns("eggs_sal_plot"),   height = "200px"),
                        plotlyOutput(ns("eggs_vel_plot"),   height = "200px")
                      ),
                      
                      h4("Egg and Larval Suitability Indices", class = "tile-title"),
                      
                      p(
                        "Hydrodynamic outputs were processed identically across life stages, but evaluated using narrower suitability thresholds reflecting early life-stage constraints. Eggs and larvae are largely passive and highly sensitive to environmental conditions, requiring very shallow depths, low velocities, moderate temperatures, and freshwater to low salinity conditions. Suitability indices were calculated for each environmental variable and combined using a geometric mean, enforcing strict multi-variable constraints on habitat viability. Within the modeled domain, high-quality habitat is effectively absent, as spawning and early development primarily occur in upstream freshwater systems not represented in the model extent. Where suitable conditions do occur, they are spatially limited and frequently coincide with elevated contaminant concentrations, indicating concentrated exposure risk.",
                        class = "helper-text"
                      )
                    ),
                    
                    tabPanel(
                      title = "Non-Migratory Juveniles",
                      
                      div(
                        style = "display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;",
                        plotlyOutput(ns("juv_depth_plot"), height = "200px"),
                        plotlyOutput(ns("juv_temp_plot"),  height = "200px"),
                        plotlyOutput(ns("juv_sal_plot"),   height = "200px"),
                        plotlyOutput(ns("juv_vel_plot"),   height = "200px")
                      ),
                      
                      h4("Juvenile Suitability Indices", class = "tile-title"),
                      
                      p(
                        "Non-migratory juveniles represent post-larval individuals with increased mobility and broader environmental tolerances. Monthly, depth-averaged hydrodynamic conditions were converted to spatial rasters and evaluated using juvenile-specific suitability functions, reflecting preference for shallow to moderate depths, low to moderate velocities, moderate temperatures, and low to moderate salinity. Suitability was calculated at the grid-cell scale using a geometric mean, capturing the combined influence of environmental variables on habitat quality. These suitability surfaces were integrated with contaminant exposure metrics to quantify habitat-dependent risk, revealing how persistent nursery habitat interacts with spatial patterns of contamination across the estuary.",
                        class = "helper-text"
                      )
                    )
                  )
                )
              )
            )
          )
        ),
        
        div(class = "section-space-small"),
        
        # ----------------------------
        # Pyramid + Map
        # ----------------------------
        fluidRow(
          
          column(
            5,
            div(
              class = "hydro-map-wrap",
              
              leafletOutput(ns("hydro_map"), width = "100%", height = "650px"),
              
              div(
                style = "margin-top: 10px;",
                radioButtons(
                  inputId = ns("habitat_layer"),
                  label   = NULL,
                  inline  = TRUE,
                  selected = "Adults",
                  choiceNames = c(
                    "Adults",
                    "Eggs and Larvae",
                    "Non-Migratory Juveniles"
                  ),
                  choiceValues = c(
                    "Adults",
                    "Eggs and Larvae",
                    "Non-Migratory Juveniles"
                  )
                )
              )
            ),
            
            div(class = "section-space-small"),
            
            h4("Penobscot River Estuary, ME", class = "tile-title"),
            p(
              "High-quality habitat summaries were generated using hydrodynamic conditions simulated for the April\u2013October 2023 period with a Delft3D model, including depth-averaged temperature, salinity, depth, and velocity.",
              class = "helper-text"
            )
          ),
          
          column(
            7,
            uiOutput(ns("pyr_canvas_js")),
            
            div(
              class = "text-center",
              style = "margin-bottom: 24px; margin-top: 40px;",
              
              h2("What is Contamination Risk?", class = "tile-title"),
              
              p(
                "In the Penobscot, contamination risk refers to the likelihood that organisms encounter, uptake, and are affected by contaminants as a result of how physical transport processes interact with biologically suitable habitat.",
                class = "helper-text"
              )
            ),
            
            div(
              id = ns("pyr_wrap"),
              style = "width: 100%; max-width: 980px; margin: 34px auto 0 auto;",
              div(id = ns("pyr_canvas"), style = "height: 380px; width: 100%;")
            ),
            
            tags$div(
              class = "hero-figure-caption",
              style = "margin-bottom: 24px; text-align: center;",
              "Click a level of the pyramid to find out more about contamination risk."
            ),
            
            div(class = "section-space-small"),
            
            card(
              class = "tile-white tile-pop",
              card_body(
                fluidRow(
                  column(
                    12,
                    div(
                      id = ns("stage_info_wrap"),
                      class = "how-to-text",
                      uiOutput(ns("stage_info"))
                    )
                  )
                )
              )
            )
          )
        ),
        
        
        # Stage info styling
        tags$style(HTML(sprintf("
          #%s.stage-info-card{
            max-width: 980px;
            margin: 16px auto 0 auto;
            padding: 16px 18px;
            border-radius: 18px;
            background: rgba(20,20,20,0.55);
            border: 1px solid rgba(255,255,255,0.10);
            color: #E6E6E6;
          }
          #%s .stage-info-title{
            margin: 0 0 6px 0;
            font-family: Arial, sans-serif;
            font-size: 18px;
            font-weight: 800;
            color: #E6E6E6;
          }
          #%s .stage-info-text{
            margin: 0;
            font-family: Arial, sans-serif;
            font-size: 14px;
            line-height: 1.45;
            color: #E6E6E6;
            opacity: 0.95;
          }
        ", ns("stage_info_wrap"), ns("stage_info_wrap"), ns("stage_info_wrap")))),
        
        div(class = "section-space"),
        
        # Contamination Risk equations
        
        fluidRow(
          column(
            12,
            h3(
              "How Can We Quantify Contamination Risk?",
              class = "tile-title",
              style = "text-align: center; margin-bottom: 24px;"
            )
          ),
          
          column(
            6,
            div(
              class = "shear-framework",
              style = "text-align: center; margin-bottom: 20px; padding: 20px;",
              
              tags$h3("Habitat Impact", class = "tile-title"),
              
              tags$p(
                "Habitat impact describes where biologically suitable habitat overlaps with elevated methylmercury concentrations, identifying locations where organisms are most likely to encounter contaminants under favorable environmental conditions.",
                class = "helper-text"
              ),
              
              withMathJax(
                tags$div(
                  class = "equation-block",
                  style = "margin-top: 35px;",
                  "$$ \\text{Impact}_{\\text{MeHg}} = \\text{HSI}_{\\text{mean}} \\times \\text{MeHg}_{\\text{norm}} $$"
                )
              ),
              
              div(
                class = "equation-definitions",
                style = "margin-top: 28px;",
                tags$p(
                  HTML(
                    "<b>Where:</b><br/>
          <i>Impact</i><sub>MeHg</sub> = habitat-specific methylmercury impact (dimensionless)<br/>
          <i>HSI</i><sub>mean</sub> = mean habitat suitability index (0\u20131)<br/>
          <i>MeHg</i><sub>norm</sub> = normalized methylmercury concentration based on ecotoxicological thresholds (0\u20131)"
                  )
                )
              )
            )
          ),
          
          column(
            6,
            div(
              class = "shear-framework",
              style = "text-align: center; margin-bottom: 20px; padding: 20px;",
              
              tags$h3("Habitat Impairment", class = "tile-title"),
              
              tags$p(
                "Habitat impairment represents the reduction in functional habitat quality caused by methylmercury exposure, accounting for the probability that contamination results in adverse biological effects.",
                class = "helper-text"
              ),
              
              withMathJax(
                tags$div(
                  class = "equation-block",
                  "$$ \\text{HabImpair}_{\\text{MeHg}} = \\text{HSI}_{\\text{mean}} \\times \\left( \\frac{\\text{MeHg}_{\\text{incidence}}}{100} \\right) $$"
                )
              ),
              
              div(
                class = "equation-definitions",
                tags$p(
                  HTML(
                    "<b>Where:</b><br/>
          <i>HabImpair</i><sub>MeHg</sub> = methylmercury-driven habitat impairment (dimensionless)<br/>
          <i>HSI</i><sub>mean</sub> = mean habitat suitability index (0\u20131)<br/>
          <i>MeHg</i><sub>incidence</sub> = percentage of observations associated with adverse biological effects based on NOAA ERL/ERM thresholds"
                  )
                )
              )
            )
          )
          
        ),
        
        # ---- STATIC MAP + TWO VERTICAL LATITUDE PROFILES -----------------------
        fluidRow(
          column(
            8,
            div(
              class = "hydro-map-wrap",
              style = "height: 600px; position: relative;",
              leafletOutput(ns("hydro_map_1"), width = "100%", height = "650px"),
              
              div(
                class = "hydro-overlay-left",
                
                div(
                  class = "overlay-section",
                  h3("IF-HI Co-occurrence Risk", class = "tile-title"),
                  p(
                    "Select one or more layers to display co-occurrence of elevated exposure intensity (Impact Factor) and habitat impairment across life stages. Per-stage layers show the number of months both metrics exceeded the 90th percentile. The summary layer shows how many life stages experienced co-occurrence at each location.",
                    class = "helper-text"
                  )
                ),
                
                div(
                  class = "overlay-section",
                  h4("Select layers", class = "tile-title"),
                  checkboxGroupInput(
                    inputId = ns("show_cooccur"),
                    label   = NULL,
                    choiceNames  = c("Adults", "Eggs and Larvae", "Non-Migratory Juveniles",
                                     "All Life Stages (summary)"),
                    choiceValues = c("Adults", "Eggs and Larvae", "Non-Migratory Juveniles",
                                     "All Life Stages"),
                    selected = "Adults"
                  ),
                  tags$div(
                    class = "hero-figure-caption",
                    style = "margin-top: 10px; text-align:center;",
                    "Select one or more layers to update the map."
                  )
                ),
                
                div(
                  class = "overlay-section",
                  h3("What This Map Shows", class = "tile-title"),
                  p(
                    "Per-stage layers (color scale: light pink = 1 month, dark red = 7 months) show how persistently each life stage’s high-exposure habitat overlapped with high-impairment habitat. The All Life Stages layer (color scale: 1–3 life stages) identifies locations where this co-occurrence was shared across multiple life stages, highlighting the persistent cross-life-stage risk hotspot.",
                    class = "helper-text"
                  )
                )
              ),
              
              tags$style(HTML("
        .hydro-overlay-left .shiny-options-group{
          display: flex;
          flex-direction: column;
          gap: 10px;
        }

        .hydro-overlay-left .shiny-options-group input[type='checkbox']{
          position: absolute;
          opacity: 0;
          pointer-events: none;
        }

        .hydro-overlay-left .shiny-options-group label{
          display: flex;
          align-items: center;
          cursor: pointer;
          user-select: none;
          margin: 0 !important;
        }

        .hydro-overlay-left .shiny-options-group label > span{
          display: inline-flex;
          align-items: center;
          gap: 10px;
          padding: 8px 10px;
          width: 100%;
          border-radius: 12px;
          border: 1px solid rgba(255,255,255,0.18);
          background: rgba(20,20,20,0.45);
          color: #E6E6E6;
          transition: background 120ms ease, border-color 120ms ease, transform 120ms ease;
        }

        .hydro-overlay-left .shiny-options-group label > span::before{
          content: '';
          width: 12px;
          height: 12px;
          border-radius: 999px;
          border: 2px solid rgba(230,230,230,0.85);
          background: transparent;
          box-sizing: border-box;
          transition: background 120ms ease, box-shadow 120ms ease, border-color 120ms ease;
        }

        .hydro-overlay-left .shiny-options-group label:hover > span{
          background: rgba(20,20,20,0.60);
          border-color: rgba(255,255,255,0.28);
          transform: translateY(-1px);
        }

        .hydro-overlay-left .shiny-options-group input[type='checkbox']:checked + span{
          font-weight: 800;
          background: rgba(20,20,20,0.70);
          border-color: rgba(255,255,255,0.35);
        }

        .hydro-overlay-left .shiny-options-group input[type='checkbox']:checked + span::before{
          background: #E6E6E6;
          border-color: #E6E6E6;
          box-shadow: 0 0 0 3px rgba(230,230,230,0.18);
        }
      "))
            )
          ),
          
          column(
            2,
            div(
              class = "tile-white tile-pop",
              style = "height: 650px; padding: 12px; display: flex; flex-direction: column;",
              h3(
                HTML("Habitat<br>Impact"),
                class = "tile-title",
                style = "text-align:center; margin-top: 0;"
              ),
              div(
                style = "flex: 1; min-height: 0;",
                plotlyOutput(ns("impact_vertical"), height = "100%")
              )
            )
          ),
          
          column(
            2,
            div(
              class = "tile-white tile-pop",
              style = "height: 650px; padding: 12px; display: flex; flex-direction: column;",
              h3("Habitat Impairment", class = "tile-title", style = "text-align:center; margin-top: 0;"),
              div(
                style = "flex: 1; min-height: 0;",
                plotlyOutput(ns("impairment_vertical"), height = "100%")
              )
            )
          )
        ),
        
        # ----------------------------
        # Cumulative Risk
        # ----------------------------
        div(class = "section-space"),
        
        fluidRow(
          h3("Cumulative Contamination Risk", class = "tile-title", style = "text-align: center;"),
          div(class = "section-space"),
          
          column(
            6,
            div(
              class = "side-image-wrap",
              style = "display: flex; align-items: center; height: 100%;",
              tags$figure(
                class = "hero-figure",
                plotly::plotlyOutput(ns("cumulative_plot"), height = "380px", width = "700px"),
                tags$div(
                  style = "width: 100%; display: flex; justify-content: center; gap: 28px; margin-top: 10px; color: #ffffff; font-size: 16px; font-weight: 600;",
                  
                  tags$div(
                    style = "display: inline-flex; align-items: center; gap: 10px; white-space: nowrap;",
                    tags$span(style = "width: 14px; height: 14px; display: inline-block; border-radius: 3px; border: 1.5px solid #ffffff; background-color: #E74C3C;"),
                    "Adult"
                  ),
                  
                  tags$div(
                    style = "display: inline-flex; align-items: center; gap: 10px; white-space: nowrap;",
                    tags$span(style = "width: 14px; height: 14px; display: inline-block; border-radius: 3px; border: 1.5px solid #ffffff; background-color: #A3D977;"),
                    "Non-Migratory Juveniles"
                  )
                ),
                tags$figcaption(
                  "Cumulative MeHg exposure opportunity (area-weighted) within high-quality habitat (HSI > 0.8) across the April\u2013October period.",
                  class = "hero-figure-caption"
                )
              )
            )
          ),
          column(
            6,
            div(
              style = "margin-top: 20px;",
              p(
                "Methylmercury risk builds up over time for different alewife life stages as fish move through and remain within the estuary. Adults exhibited moderate cumulative exposure intensity (10.78 km\u00b2) and impaired habitat (33.35 km\u00b2), indicating sustained but spatially constrained exposure over the season. Eggs and larvae had no measurable cumulative exposure within the modeled domain, reflecting the absence of persistent high-quality habitat in the estuarine portion of the system. Non-migratory juveniles exhibited substantially greater cumulative exposure, with exposure intensity totaling 51.93 km\u00b2 and cumulative impaired habitat reaching 1,867 km\u00b2\u2014a large value driven by repeated occurrence of impairment across both space and time.",
                class = "helper-text"
              ),
              p(
                "These differences reflect how often and how long suitable habitat overlaps contaminated areas as habitat availability shifts through the season. Adults experience a focused window of overlap in late summer when habitat peaks, while non-migratory juveniles experience extensive and recurring exposure throughout the seasonal period due to the large extent and persistence of their suitable habitat. The disproportionate cumulative burden on juveniles is particularly important given their prolonged residence within estuarine habitat prior to first outmigration.",
                class = "helper-text"
              ),
              p(
                "Importantly, these differences indicate that cumulative risk is not driven by changes in exposure intensity alone, but by how long each life stage remains within the estuary and how consistently suitable habitat overlaps contaminated areas. Life stages with prolonged residence or repeated use of the same habitat patches may experience substantial cumulative risk even when contamination levels remain constant. This highlights the importance of evaluating contamination risk over time and across life stages when considering population-level impacts and management actions.",
                class = "helper-text"
              )
            )
          )
        ),
        
        
        # ----------------------------
        # Persistent Risk
        # ----------------------------
        div(class = "section-space"),
        
        fluidRow(
          h3(
            "Persistent Risk Across Life Stages",
            class = "tile-title",
            style = "text-align: center;"
          ),
          
          column(4, plotly::plotlyOutput(ns("pie_adult_hotspot"), height = "350px")),
          column(4, plotly::plotlyOutput(ns("pie_egg_hotspot"), height = "350px")),
          column(4, plotly::plotlyOutput(ns("pie_juvenile_hotspot"), height = "350px")),
          
          # ---- Interpretation card ----
          column(
            width = 10,
            offset = 1,
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
                  h3(
                    "What Does This Mean for Risk, Engineering, and Restoration?",
                    class = "tile-title",
                    style = "font-weight: 700; color:#0f1f2d !important;"
                  )),
                p(
                  "A persistent methylmeThese findings suggest that exposure potential may not be distributed evenly throughout the estuary. Instead, modeled risk becomes concentrated in locations where elevated methylmercury concentrations repeatedly overlap with biologically suitable habitat across seasons and life stages. For engineering and restoration, this highlights the importance of considering not only where contamination is present, but also where contamination overlaps with habitat that is predicted to be important to multiple life stages. The results suggest that management actions occurring within areas of persistent overlap could have the potential to influence exposure opportunity across several life stages simultaneously, whereas actions focused solely on contaminant concentrations or habitat quality independently may not capture the full spatial structure of risk. More broadly, the analysis demonstrates how integrating hydrodynamics, habitat suitability, and contaminant distributions can help identify locations where ecological vulnerability may be concentrated and where restoration actions could potentially provide the greatest reduction in modeled exposure opportunity.",
                  class = "helper-text",
                  style = "text-align: center; margin-bottom: 0;"
                )
              )
            )
          )
        ),
        
        # ----------------------------
        # Key References
        # ----------------------------
        
        div(class = "section-space"),
        
        fluidRow(
          h3("Key References", class = "tile-title", style = "text-align: center;"),
          
          p(
            "The contamination risk framework presented in this section is informed by site-specific mercury investigations in the Penobscot River, established sediment quality guidelines, and life-stage-specific habitat modeling for anadromous fishes. Key references supporting the risk metrics, thresholds, and habitat integration approach are listed below.",
            class = "helper-text"
          ),
          
          tags$ul(
            class = "helper-text reference-list",
            
            tags$li(
              "Agency for Toxic Substances and Disease Registry. (2021). ",
              tags$em("Health consultation: Review of anadromous fish, Penobscot River"),
              ". U.S. Department of Health and Human Services. ",
              tags$a(
                href = "https://www.atsdr.cdc.gov",
                "https://www.atsdr.cdc.gov",
                target = "_blank"
              )
            ),
            
            tags$li(
              "Bodaly, R. A., & Kopec, A. D. (2013). ",
              tags$em("Penobscot River Mercury Study: Phase II environmental study"),
              ", Chapter 9: Upstream limit of mercury contamination in surface sediments. U.S. District Court."
            ),
            
            tags$li(
              "Bodaly, R. A., Rudd, J. W. M., Fisher, N. S., & Whipple, C. G. (2008). ",
              tags$em("Penobscot River Mercury Study: Phase I environmental study 2006\u20132007"),
              ". U.S. District Court. ",
              tags$a(
                href = "https://www.penobscotmercurystudy.com/__data/assets/pdf_file/0012/120234/382-document-phase-1-study-report-20080125.pdf",
                "Report PDF",
                target = "_blank"
              )
            ),
            
            tags$li(
              "Hall, B. D., Bodaly, R. A., Fudge, R. J. P., Rudd, J. W. M., & Rosenberg, D. M. (1997). Food as the dominant pathway of methylmercury uptake by fish. ",
              tags$em("Water, Air, and Soil Pollution"),
              ", 100(1\u20132), 13\u201324. ",
              tags$a(
                href = "https://doi.org/10.1023/A:1018071406537",
                "https://doi.org/10.1023/A:1018071406537",
                target = "_blank"
              )
            ),
            
            tags$li(
              "(NOAA) National Oceanic and Atmospheric Administration. (1990). ",
              tags$em("Sediment quality guidelines developed for the National Status and Trends Program"),
              ". National Oceanic and Atmospheric Administration. ",
              tags$a(
                href = "https://rais.ornl.gov/documents/ECO_BENCH_NOAA.pdf",
                "Guidelines PDF",
                target = "_blank"
              )
            ),
            
            tags$li(
              "Quintana, V., Huguenard, K., Stevens, J., McKay, K., Galaitsi, S., Abate, M., & Jacobs, A. (in prep). ",
              tags$em("River herring habitat in the Eastern United States"),
              ". Manuscript in preparation."
            ),
            
            tags$li(
              "U.S. Environmental Protection Agency. (2015). ",
              tags$em("The Penobscot River and environmental contaminants: Assessment of Tribal exposure through sustenance lifeways"),
              " (EPA-901-R-15-002). U.S. Environmental Protection Agency, Region 1."
            )
          )
        )
      )
    )
  )
}


# ============================
# SERVER
# ============================
tab_static_risk_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Milford Dam Fish Lift
    fish <- read_csv("data/Habitat/Milford_Fish_Lift_2023.csv") %>%
      mutate(
        Date = as.Date(Date, format = "%m/%d/%Y"),
        Month = factor(
          as.character(lubridate::month(Date, label = TRUE, abbr = TRUE)),
          levels = month.abb
        )
      )
    
    # --- load spatial data once ---
    r_mercury       <- terra::rast("data/k_mercury.tif")
    r_methylmercury <- terra::rast("data/k_methylmercury.tif")
    
    r_mercury[r_mercury <= 0]             <- NA
    r_methylmercury[r_methylmercury <= 0] <- NA
    
    r_mercury_ll       <- terra::project(r_mercury, "EPSG:4326")
    r_methylmercury_ll <- terra::project(r_methylmercury, "EPSG:4326")
    
    e1 <- terra::ext(r_mercury_ll)
    e2 <- terra::ext(r_methylmercury_ll)
    
    e <- terra::ext(
      min(e1$xmin, e2$xmin),
      max(e1$xmax, e2$xmax),
      min(e1$ymin, e2$ymin),
      max(e1$ymax, e2$ymax)
    )
    
    # Load HSI persistence rasters (months present, 0-7)
    r_hsi_adult <- terra::rast("data/Habitat/HSI_months_present_adult.tif")
    r_hsi_eggs  <- terra::rast("data/Habitat/HSI_months_present_egg_larvae.tif")
    r_hsi_juv   <- terra::rast("data/Habitat/HSI_months_present_nonmigratory_juvenile.tif")
    
    # remove zero / background so map shows only cells with presence
    r_hsi_adult[r_hsi_adult <= 0] <- NA
    r_hsi_eggs[r_hsi_eggs   <= 0] <- NA
    r_hsi_juv[r_hsi_juv     <= 0] <- NA
    
    # project to lon/lat for leaflet
    r_hsi_adult_ll <- terra::project(r_hsi_adult, "EPSG:4326")
    r_hsi_eggs_ll  <- terra::project(r_hsi_eggs,  "EPSG:4326")
    r_hsi_juv_ll   <- terra::project(r_hsi_juv,   "EPSG:4326")
    
    # Exact 1-7 palette matching dissertation Figure 3.5 / manuscript maps.
    # colorBin with 7 bins over domain 0.5-7.5 maps each integer 1-7 to its
    # own color bin — this works correctly with addRasterImage.
    hsi_month_colors <- c(
      "#D73027",  # 1 month  — red
      "#FC8D59",  # 2 months — orange
      "#FEE08B",  # 3 months — tan/yellow
      "#D9EF8B",  # 4 months — yellow-green
      "#91CF60",  # 5 months — light green
      "#31A354",  # 6 months — medium green
      "#006837"   # 7 months — dark green
    )
    
    pal_hsi_months <- leaflet::colorBin(
      palette  = hsi_month_colors,
      bins     = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5),
      domain   = c(1, 7),
      na.color = "transparent"
    )
    
    # study domain outline (kept for spatial context)
    s_study  <- terra::vect("data/Habitat/Penobscot_Model_Domain.shp")
    
    # ── Second map: co-occurrence rasters ─────────────────────────────────────
    # Per-life-stage IF-HI co-occurrence persistence (0-7 months)
    r_cooccur_adult <- terra::rast("data/Habitat/IF_HI_cooccurrence_months_hotspot_adult.tif")
    r_cooccur_eggs  <- terra::rast("data/Habitat/IF_HI_cooccurrence_months_hotspot_egg_larvae.tif")
    r_cooccur_juv   <- terra::rast("data/Habitat/IF_HI_cooccurrence_months_hotspot_nonmigratory_juvenile.tif")
    # Cross-life-stage summary: number of life stages with any co-occurrence (0-3)
    r_n_stages      <- terra::rast("data/Habitat/n_lifestages_any_cooccur.tif")
    
    # mask zeros so background is transparent
    r_cooccur_adult[r_cooccur_adult <= 0] <- NA
    r_cooccur_eggs[r_cooccur_eggs   <= 0] <- NA
    r_cooccur_juv[r_cooccur_juv     <= 0] <- NA
    r_n_stages[r_n_stages           <= 0] <- NA
    
    # project to lon/lat
    r_cooccur_adult_ll <- terra::project(r_cooccur_adult, "EPSG:4326")
    r_cooccur_eggs_ll  <- terra::project(r_cooccur_eggs,  "EPSG:4326")
    r_cooccur_juv_ll   <- terra::project(r_cooccur_juv,   "EPSG:4326")
    r_n_stages_ll      <- terra::project(r_n_stages,      "EPSG:4326")
    
    # Palette for per-stage co-occurrence (0-7 months) — same red scale as Figure 5
    # white=0 masked, light pink=1 … dark red=7
    cooccur_colors <- c(
      "#FDDBC7",  # 1 month
      "#F4A582",  # 2 months
      "#D6604D",  # 3 months
      "#B2182B",  # 4 months
      "#8B0000",  # 5 months
      "#67000D",  # 6 months
      "#3D0007"   # 7 months
    )
    pal_cooccur <- leaflet::colorBin(
      palette  = cooccur_colors,
      bins     = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5),
      domain   = c(1, 7),
      na.color = "transparent"
    )
    
    # Palette for n_lifestages_any_cooccur (1-3) — white→pink→red→dark red (Figure 6)
    pal_n_stages <- leaflet::colorBin(
      palette  = c("#FCBBA1", "#D6604D", "#67000D"),
      bins     = c(0.5, 1.5, 2.5, 3.5),
      domain   = c(1, 3),
      na.color = "transparent"
    )
    
    # study domain outline (kept for context on both maps)
    study_sf <- sf::st_as_sf(s_study) |> sf::st_transform(4326)
    
    # ── Shapefiles for latitude profile plots ─────────────────────────────────
    # Habitat Impact
    if_adults <- terra::vect("data/Habitat/Habitat_Impact_Summary_Adult.shp")
    if_eggs   <- terra::vect("data/Habitat/Habitat_Impact_Summary_EggLarvae.shp")
    if_juv    <- terra::vect("data/Habitat/Habitat_Impact_Summary_Juvenile.shp")
    
    # Habitat Impairment
    hi_adults <- terra::vect("data/Habitat/Habitat_Impairment_Summary_Adult.shp")
    hi_eggs   <- terra::vect("data/Habitat/Habitat_Impairment_Summary_EggLarvae.shp")
    hi_juv    <- terra::vect("data/Habitat/Habitat_Impairment_Summary_Juvenile.shp")
    
    # convert to sf (profile plots only — no hatch lines needed)
    if_adults_sf <- sf::st_as_sf(if_adults) |> sf::st_transform(4326)
    if_eggs_sf   <- sf::st_as_sf(if_eggs)   |> sf::st_transform(4326)
    if_juv_sf    <- sf::st_as_sf(if_juv)    |> sf::st_transform(4326)
    
    hi_adults_sf <- sf::st_as_sf(hi_adults) |> sf::st_transform(4326)
    hi_eggs_sf   <- sf::st_as_sf(hi_eggs)   |> sf::st_transform(4326)
    hi_juv_sf    <- sf::st_as_sf(hi_juv)    |> sf::st_transform(4326)
    
    # Reference sites
    dams <- data.frame(
      name = c("Veazie Dam", "Great Works Dam", "Milford Dam", "West Enfield Dam"),
      status = c("Demolished (2013)", "Demolished (2012)", "Operational", "Operational \u2013 discharge reference site"),
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
    
    # ============================
    # Suitability Index Data
    # ============================
    
    # Adult Alewife
    adult_alewife_temp_suitability_data <- data.frame(
      Temperature = c(0, 3, 5, 8, 10.5, 12, 16, 22, 27, 30),
      SuitabilityIndex = c(0.0, 0.1, 0.5, 0.7, 0.8, 1.0, 0.8, 0.5, 0.0, 0.0)
    )
    
    adult_alewife_depth_suitability_data <- data.frame(
      Depth = c(-3, 0, 2, 5, 10, 15, 20, 25),
      SuitabilityIndex = c(1.0, 1.0, 0.8, 0.5, 0.3, 0.1, 0.0, 0.0)
    )
    
    adult_alewife_salinity_suitability_data <- data.frame(
      Salinity = c(0, 8, 15, 20, 25),
      SuitabilityIndex = c(1.0, 0.5, 0.3, 0.0, 0.0)
    )
    
    adult_alewife_velocity_suitability_data <- data.frame(
      Velocity = c(0, 0.3, 1.7, 3.5, 4.5, 5.0),
      SuitabilityIndex = c(1.0, 0.8, 0.5, 0.3, 0.0, 0.0)
    )
    
    # Alewife Eggs & Larvae
    alewife_eggs_temp_suitability_data <- data.frame(
      Temperature = c(0, 3, 7, 11, 16, 28, 30, 35),
      SuitabilityIndex = c(0.0, 0.1, 0.3, 0.5, 1.0, 0.1, 0.0, 0.0)
    )
    
    alewife_eggs_depth_suitability_data <- data.frame(
      Depth = c(-3, 0, 2, 5, 10, 15),
      SuitabilityIndex = c(0.8, 1.0, 0.8, 0.1, 0.0, 0.0)
    )
    
    alewife_eggs_salinity_suitability_data <- data.frame(
      Salinity = c(0, 0.5, 5, 12, 20, 25),
      SuitabilityIndex = c(0.8, 1.0, 0.75, 0.5, 0.1, 0.0)
    )
    
    alewife_eggs_velocity_suitability_data <- data.frame(
      Velocity = c(0, 0.03, 0.12, 0.3, 3.5, 4.5, 5),
      SuitabilityIndex = c(0.7, 1.0, 0.5, 0.3, 0.1, 0.0, 0.0)
    )
    
    # Juvenile Alewife
    juvenile_alewife_temp_suitability_data <- data.frame(
      Temperature = c(0, 3, 7, 11, 20, 23, 28, 30),
      SuitabilityIndex = c(0.0, 0.1, 0.5, 0.8, 1.0, 0.5, 0.1, 0.0)
    )
    
    juvenile_alewife_depth_suitability_data <- data.frame(
      Depth = c(-3, 0, 5, 10, 20, 25),
      SuitabilityIndex = c(0.5, 1.0, 0.7, 0.5, 0.0, 0.0)
    )
    
    juvenile_alewife_salinity_suitability_data <- data.frame(
      Salinity = c(0, 0.5, 10, 25, 30),
      SuitabilityIndex = c(0.0, 0.5, 1.0, 0.8, 0.0)
    )
    
    juvenile_alewife_velocity_suitability_data <- data.frame(
      Velocity = c(0, 0.1, 0.17, 0.3, 3.5, 4.5, 5),
      SuitabilityIndex = c(1.0, 0.7, 0.5, 0.3, 0.1, 0.0, 0.0)
    )
    
    # -----------------------------
    # Glossary Tab
    # -----------------------------
    observeEvent(input$toggle_glossary, {
      shinyjs::toggleClass(id = ns("glossary_tab"), class = "open")
    })
    
    # -----------------------------
    # Milford Dam ridgeline plot
    # -----------------------------
    output$ridge_int <- renderPlotly({
      
      req(exists("fish"))
      req(is.data.frame(fish))
      req(nrow(fish) > 0)
      req(all(c("Date", "num_alewives") %in% names(fish)))
      
      df <- fish %>%
        mutate(
          Date = as.Date(Date, format = "%m/%d/%Y"),
          num_alewives = as.numeric(num_alewives),
          hover = paste0(
            "Date: ", Date,
            "<br>Alewives: ", scales::comma(num_alewives)
          )
        ) %>%
        arrange(Date)
      
      plotly::plot_ly(
        data = df,
        x = ~Date,
        y = ~num_alewives,
        type = "scatter",
        mode = "lines",
        fill = "tozeroy",
        text = ~hover,
        hoverinfo = "text",
        line = list(color = "#1E8449"),
        fillcolor = "rgba(46, 204, 113, 0.75)"
      ) %>%
        plotly::layout(
          title = list(
            text = "<b>Alewife Passage Timing</b><br><sup>Milford Fish Lift</sup>",
            font = list(size = 20, color = "#ffffff")
          ),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font = list(color = "#ffffff", size = 18),
          xaxis = list(
            title = "Date",
            color = "#ffffff",
            tickfont  = list(color = "#ffffff", size = 18),
            titlefont = list(color = "#ffffff", size = 18),
            zeroline = FALSE,
            showgrid = FALSE,
            type = "date",
            tickformat = "%b %d"
          ),
          yaxis = list(
            title = "Number of river herring",
            color = "#ffffff",
            tickfont  = list(color = "#ffffff", size = 18),
            titlefont = list(color = "#ffffff", size = 18),
            gridcolor = "#ffffff",
            zeroline = FALSE,
            rangemode = "tozero"
          ),
          margin = list(l = 80, r = 25, t = 65, b = 75)
        ) %>%
        plotly::config(displayModeBar = FALSE)
      
    })
    
    # -----------------------------
    # Shared factor levels and colors
    # -----------------------------
    month_levels     <- c("Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct")
    life_stage_levels <- c("adult", "egg_larvae", "nonmigratory_juvenile")
    
    life_stage_labels <- c(
      "adult"                 = "Adult",
      "egg_larvae"            = "Egg and Larvae",
      "nonmigratory_juvenile" = "Non-Migratory Juvenile"
    )
    
    lifestage_colors <- c(
      "adult"                 = "#d73027",
      "egg_larvae"            = "#fee08b",
      "nonmigratory_juvenile" = "#91cf60"
    )
    
    # -----------------------------
    # Seasonal Habitat Quality data
    # -----------------------------
    impact_risk_mehg  <- readr::read_csv("data/Habitat/impact_risk_mehg_violin_input.csv", show_col_types = FALSE)
    impairment_df     <- readr::read_csv("data/Habitat/impairment_total_violin_input.csv", show_col_types = FALSE)
    seasonal_cum_long <- readr::read_csv("data/Habitat/seasonal_cumulative_long_hsi08.csv", show_col_types = FALSE)
    
    impact_risk_mehg <- impact_risk_mehg |>
      dplyr::mutate(
        Month     = factor(Month, levels = month_levels),
        LifeStage = factor(LifeStage, levels = life_stage_levels)
      )
    
    impairment_df <- impairment_df |>
      dplyr::mutate(
        Month     = factor(Month, levels = month_levels),
        LifeStage = factor(LifeStage, levels = life_stage_levels)
      )
    
    seasonal_cum_long <- seasonal_cum_long |>
      dplyr::mutate(
        LifeStage = factor(LifeStage, levels = life_stage_levels),
        Metric    = factor(Metric, levels = c("Exposure Intensity", "Impaired Habitat"))
      )
    
    # HQ habitat area — hard-coded from Figure 3.4 / dissertation results
    # Adults:    peaks ~145 km² in Aug; also present Jul (~9 km²), Sep (~42 km²)
    # Eggs/larvae: effectively 0 all months (zero-limiting formulation)
    # Juveniles: peaks ~6,400–6,600 km² Jul–Aug; present May–Oct
    # Values in km² (converted to m² for y-axis: multiply by 1e6)
    hq_area_summary <- dplyr::bind_rows(
      # Adults
      data.frame(Month = "Apr", LifeStage = "adult",                 HQ_Area_km2 = 0),
      data.frame(Month = "May", LifeStage = "adult",                 HQ_Area_km2 = 0),
      data.frame(Month = "Jun", LifeStage = "adult",                 HQ_Area_km2 = 0),
      data.frame(Month = "Jul", LifeStage = "adult",                 HQ_Area_km2 = 9),
      data.frame(Month = "Aug", LifeStage = "adult",                 HQ_Area_km2 = 145),
      data.frame(Month = "Sep", LifeStage = "adult",                 HQ_Area_km2 = 42),
      data.frame(Month = "Oct", LifeStage = "adult",                 HQ_Area_km2 = 0),
      # Eggs and larvae — effectively absent
      data.frame(Month = "Apr", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "May", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "Jun", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "Jul", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "Aug", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "Sep", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      data.frame(Month = "Oct", LifeStage = "egg_larvae",            HQ_Area_km2 = 0),
      # Non-migratory juveniles
      data.frame(Month = "Apr", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 0),
      data.frame(Month = "May", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 600),
      data.frame(Month = "Jun", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 2200),
      data.frame(Month = "Jul", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 6400),
      data.frame(Month = "Aug", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 6600),
      data.frame(Month = "Sep", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 5000),
      data.frame(Month = "Oct", LifeStage = "nonmigratory_juvenile", HQ_Area_km2 = 2600)
    ) |>
      dplyr::mutate(
        Month     = factor(Month, levels = month_levels),
        LifeStage = factor(LifeStage, levels = life_stage_levels)
      ) |>
      dplyr::arrange(Month, LifeStage)
    
    # Facet labels matching dissertation panel labels
    hq_facet_labels <- c(
      "adult"                 = "a. Adult",
      "egg_larvae"            = "b. Egg and Larvae",
      "nonmigratory_juvenile" = "c. Non-Migratory Juvenile"
    )
    
    make_hq_area_plot <- function(dat) {
      dat$LifeStage <- factor(dat$LifeStage, levels = life_stage_levels)
      
      ggplot2::ggplot(dat, ggplot2::aes(x = Month, y = HQ_Area_km2, fill = LifeStage)) +
        ggplot2::geom_col(
          width = 0.72,
          color = "#ffffff",
          linewidth = 0.3
        ) +
        ggplot2::facet_wrap(
          ~ LifeStage,
          ncol = 1,
          scales = "free_y",
          labeller = ggplot2::as_labeller(hq_facet_labels)
        ) +
        ggplot2::scale_fill_manual(
          values = lifestage_colors,
          breaks = life_stage_levels,
          name = NULL
        ) +
        ggplot2::scale_y_continuous(
          labels = scales::label_comma(),
          expand = ggplot2::expansion(mult = c(0, 0.06))
        ) +
        ggplot2::labs(x = NULL, y = "Habitat Area (km²)") +
        ggplot2::theme_minimal(base_size = 14) +
        ggplot2::theme(
          plot.background  = ggplot2::element_rect(fill = "transparent", color = NA),
          panel.background = ggplot2::element_rect(fill = "transparent", color = NA),
          text             = ggplot2::element_text(color = "#ffffff"),
          axis.text.x      = ggplot2::element_text(size = 13, color = "#ffffff",
                                                   angle = 45, hjust = 1),
          axis.text.y      = ggplot2::element_text(size = 13, color = "#ffffff"),
          axis.title.y     = ggplot2::element_text(size = 14, color = "#ffffff",
                                                   margin = ggplot2::margin(r = 10)),
          strip.text       = ggplot2::element_text(size = 14, color = "#ffffff",
                                                   face = "plain", hjust = 0),
          strip.background = ggplot2::element_rect(fill = "transparent", color = NA),
          panel.grid.minor   = ggplot2::element_blank(),
          panel.grid.major.x = ggplot2::element_blank(),
          panel.grid.major.y = ggplot2::element_line(color = "rgba(255,255,255,0.3)",
                                                     linewidth = 0.35),
          legend.position  = "none",
          plot.margin      = ggplot2::margin(12, 14, 12, 14)
        )
    }
    
    output$hq_area_plot <- plotly::renderPlotly({
      p <- make_hq_area_plot(hq_area_summary)
      
      g <- plotly::ggplotly(p, tooltip = c("x", "y"))
      
      g <- g |>
        plotly::layout(
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font = list(color = "#ffffff"),
          margin = list(l = 90, r = 10, t = 20, b = 50)
        )
      
      for (ax in c("xaxis", "xaxis2", "xaxis3")) {
        if (!is.null(g$x$layout[[ax]])) {
          g$x$layout[[ax]]$color <- "#ffffff"
          g$x$layout[[ax]]$tickfont <- list(color = "#ffffff")
          g$x$layout[[ax]]$zeroline <- FALSE
          g$x$layout[[ax]]$title <- list(text = "")
        }
      }
      
      for (ax in c("yaxis", "yaxis2", "yaxis3")) {
        if (!is.null(g$x$layout[[ax]])) {
          g$x$layout[[ax]]$color <- "#ffffff"
          g$x$layout[[ax]]$tickfont <- list(color = "#ffffff")
          g$x$layout[[ax]]$gridcolor <- "rgba(255,255,255,0.25)"
          g$x$layout[[ax]]$zeroline <- FALSE
          g$x$layout[[ax]]$title <- list(text = "")
        }
      }
      
      g$x$layout$yaxis$title <- list(
        text = "Habitat Area (km²)",
        font = list(color = "#ffffff", size = 14)
      )
      
      g
    })
    
    # -----------------------------
    # Pyramid
    # -----------------------------
    # Default selection for description panel
    selected <- reactiveVal("population")
    
    # Update selection from CanvasJS click
    observeEvent(input$stage_selected, {
      req(input$stage_selected)
      selected(input$stage_selected)
    })
    
    # CanvasJS pyramid
    output$pyr_canvas_js <- renderUI({
      tagList(
        tags$script(src = "https://cdn.canvasjs.com/canvasjs.min.js"),
        
        tags$script(HTML(sprintf("
          (function(){
            function renderPyramid(){
              var el = document.getElementById('%s');
              if(!el || !window.CanvasJS) {
                setTimeout(renderPyramid, 50);
                return;
              }

              var chart = new CanvasJS.Chart('%s', {
                animationEnabled: true,
                backgroundColor: 'transparent',

                data: [{
                  type: 'pyramid',

                  indexLabelFontSize: 18,
                  indexLabelFontFamily: 'Arial',
                  indexLabelFontWeight: '700',
                  indexLabelFontColor: '#E6E6E6',

                  toolTipContent: '{label}',
                  toolTip: {
                    fontFamily: 'Arial',
                    fontSize: 12,
                    cornerRadius: 10,
                    contentFormatter: function(e){
                      var dp = e.entries[0].dataPoint;
                      return '<div style=\"padding:6px 6px; max-width: 320px;\">' +
                               '<div style=\"font-weight:800; margin-bottom:4px;\">' + dp.label + '</div>' +
                               '<div style=\"line-height:1.35;\">' + dp.description + '</div>' +
                             '</div>';
                    }
                  },

                  click: function(e){
                    if(window.Shiny){
                      Shiny.setInputValue('%s', e.dataPoint.stageKey, {priority: 'event'});
                    }
                  },

                  dataPoints: [
                  // bottom (widest)
                  {
                    y: 40,
                    label: 'Population Level Risk',
                    stageKey: 'population',
                    color: '#5a5a5a',
                    description: 'Population level risk summarizes how life stage specific exposure can translate into cumulative effects on recruitment and abundance. Small impacts early in life can reduce out migration, while adult impacts can reduce spawning success and repeat spawning.'
                  },
                
                  {
                    y: 40,
                    label: 'Adults',
                    stageKey: 'adults',
                    color: '#b3392f',
                    description: 'Adult alewives migrate through the estuary and river to reach spawning habitat, then out migrate after spawning. Exposure opportunity depends on when migration overlaps with turbidity, resuspension, and retention zones that shift with discharge and tide in the Penobscot River.'
                  },
                
                  {
                    y: 40,
                    label: 'Non-Migratory Juveniles',
                    stageKey: 'juveniles',
                    color: '#d6c33a',
                    description: 'Juvenile alewives rear for weeks to months and actively feed while using lower velocity habitat for refuge. Longer residence time increases repeated contact with suspended particulate matter and contaminated fine sediments, linking retention and resuspension zones to exposure opportunity.'
                  },
                
                  // top (narrowest)
                  {
                    y: 40,
                    label: 'Eggs and Larvae',
                    stageKey: 'eggs',
                    color: '#3e8f3e',
                    description: 'In the Penobscot River, alewife eggs are deposited in freshwater spawning habitat upstream and larvae disperse as they develop. Early life stages are sensitive to hydrodynamic conditions that shape where fine particles and organic material concentrate during spawning and early rearing.'
                  }
                ]
                }]
              });

              chart.render();
            }

            renderPyramid();

            // Re-render on tab navigation or re-draw events
            document.addEventListener('DOMContentLoaded', function(){ setTimeout(renderPyramid, 0); });

            if(window.Shiny){
              document.addEventListener('shiny:value', function(){ setTimeout(renderPyramid, 50); });
              document.addEventListener('shiny:connected', function(){ setTimeout(renderPyramid, 200); });
            }
          })();
        ",
                                 ns("pyr_canvas"),        # exists check
                                 ns("pyr_canvas"),        # chart container id
                                 ns("stage_selected")     # namespaced input id
        )))
      )
    })
    
    # Life stage description panel content (click driven)
    output$stage_info <- renderUI({
      stage <- selected()
      
      info <- switch(
        stage,
        
        eggs = list(
          title = "Eggs and Larvae",
          text  = paste(
            "In the Penobscot River, alewife eggs are typically deposited in freshwater spawning habitat upstream,",
            "then larvae drift or disperse downstream as they develop. Early life stages have limited swimming ability,",
            "so exposure opportunity is strongly shaped by where fine particles and organic material accumulate during the",
            "spawning and early rearing period. Because methylmercury can move through food webs, conditions that elevate",
            "suspended particulate matter and associated contaminants can influence growth and survival at a sensitive life stage."
          )
        ),
        
        juveniles = list(
          title = "Non-Migratory Juveniles",
          text  = paste(
            "Non-Migratory juvenile alewives rear for weeks to months and often occupy shallow, low velocity areas where food is available",
            "and energetic costs are lower. Longer residence time can increase repeated contact with suspended particulate matter",
            "and contaminated fine sediments, especially when hydrodynamic conditions promote retention or resuspension. Juveniles",
            "are actively feeding, so exposure can occur through both habitat contact and diet, linking material transport to",
            "bioaccumulation potential."
          )
        ),
        
        adults = list(
          title = "Adults",
          text  = paste(
            "Adult alewives migrate into the estuary and river in spring to reach spawning habitat, then out migrate after spawning.",
            "Because adults traverse a broad range of flow and salinity conditions, exposure opportunity depends on when and where they",
            "encounter turbidity, resuspended material, and zones of retention. In the Penobscot River, hydrodynamic regime and discharge",
            "can shift the location of fine particle accumulation and transport direction, changing overlap between migration corridors and",
            "contaminated material. Adult exposure matters because it can influence energetic condition and spawning success."
          )
        ),
        
        population = list(
          title = "Population Risk",
          text  = paste(
            "Population level risk summarizes how life stage specific exposure can translate into cumulative impacts on recruitment and abundance.",
            "For alewives, small losses or sublethal effects early in life can reduce the number of juveniles that survive to out migration,",
            "while adult impacts can reduce spawning success and repeat spawning potential. The timing of migration relative to hydrodynamic",
            "conditions can create years with higher or lower system wide risk even when average contaminant concentrations remain similar."
          )
        ),
        
        list(
          title = "Select a life stage",
          text  = "Click a pyramid layer to view a description."
        )
      )
      
      div(
        div(
          h3(
            info$title,
            class = "tile-title",
            style = "font-weight: 700; color:#0f1f2d !important;"
          )),
        p(info$text, class = "helper-text", style = "margin-bottom: 0;")
      )
    })
    
    # -----------------------------
    # Habitat Map (first map) — HSI persistence rasters
    # -----------------------------
    output$hydro_map <- renderLeaflet({
      
      rng_hg   <- terra::global(r_mercury_ll, range, na.rm = TRUE)[1, ]
      rng_mehg <- terra::global(r_methylmercury_ll, range, na.rm = TRUE)[1, ]
      
      pal_hg <- leaflet::colorNumeric(
        palette = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
        domain  = rng_hg, na.color = "transparent"
      )
      pal_mehg <- leaflet::colorNumeric(
        palette = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
        domain  = rng_mehg, na.color = "transparent"
      )
      
      leaflet() |>
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldTerrain, group = "Terrain") |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
        
        # Study domain outline for context
        addPolygons(
          data = study_sf, group = "Study Area",
          color = "#444444", weight = 1.5, fillOpacity = 0, opacity = 0.7,
          dashArray = "5, 5"
        ) |>
        
        # HSI persistence rasters — one per life stage, toggled by radio buttons
        addRasterImage(r_hsi_adult_ll, colors = pal_hsi_months, opacity = 0.8,
                       project = FALSE, group = "Adults") |>
        addRasterImage(r_hsi_eggs_ll,  colors = pal_hsi_months, opacity = 0.8,
                       project = FALSE, group = "Eggs and Larvae") |>
        addRasterImage(r_hsi_juv_ll,   colors = pal_hsi_months, opacity = 0.8,
                       project = FALSE, group = "Non-Migratory Juveniles") |>
        
        # Show Adults by default (matches radio button default = "Study Area" then
        # observer fires immediately); hide the other two
        hideGroup(c("Eggs and Larvae", "Non-Migratory Juveniles")) |>
        
        # MeHg / THg rasters as optional overlays
        addRasterImage(r_mercury_ll,       colors = pal_hg,   opacity = 0.65,
                       project = FALSE, group = "Mercury (THg)") |>
        addRasterImage(r_methylmercury_ll, colors = pal_mehg, opacity = 0.65,
                       project = FALSE, group = "Methylmercury (MeHg)") |>
        
        addAwesomeMarkers(data = dams, lng = ~lng, lat = ~lat, icon = dam_icon,
                          label = ~name,
                          popup = ~paste0("<b>", name, "</b><br/>Status: ", status),
                          group = "Dams") |>
        addAwesomeMarkers(data = pollution, lng = ~lng, lat = ~lat,
                          icon = pollution_icon, label = ~name,
                          popup = ~paste0("<b>", name, "</b><br/>", role),
                          group = "Pollution Sources") |>
        
        addLayersControl(
          baseGroups = c("Light", "Terrain", "Satellite"),
          overlayGroups = c("Mercury (THg)", "Methylmercury (MeHg)",
                            "Dams", "Pollution Sources"),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        
        # HSI persistence legend — 1-7 discrete bins matching figure palette
        addLegend(
          pal      = pal_hsi_months,
          values   = 1:7,
          title    = "Months<br>Present",
          opacity  = 1,
          position = "bottomleft",
          labFormat = leaflet::labelFormat(
            transform = function(x) round(x)
          )
        ) |>
        addLegend(pal = pal_hg,
                  values = seq(rng_hg[[1]], rng_hg[[2]], length.out = 7),
                  title = "Total Mercury (THg)", opacity = 1,
                  group = "Mercury (THg)", position = "bottomright") |>
        addLegend(pal = pal_mehg,
                  values = seq(rng_mehg[[1]], rng_mehg[[2]], length.out = 7),
                  title = "Methylmercury (MeHg)", opacity = 1,
                  group = "Methylmercury (MeHg)", position = "bottomright") |>
        
        hideGroup(c("Mercury (THg)", "Methylmercury (MeHg)")) |>
        fitBounds(
          lng1 = min(terra::ext(r_hsi_juv_ll)$xmin, terra::ext(r_hsi_adult_ll)$xmin),
          lat1 = min(terra::ext(r_hsi_juv_ll)$ymin, terra::ext(r_hsi_adult_ll)$ymin),
          lng2 = max(terra::ext(r_hsi_juv_ll)$xmax, terra::ext(r_hsi_adult_ll)$xmax),
          lat2 = max(terra::ext(r_hsi_juv_ll)$ymax, terra::ext(r_hsi_adult_ll)$ymax)
        )
    })
    
    # Radio button toggles which HSI raster is shown
    observeEvent(input$habitat_layer, {
      req(input$habitat_layer)
      proxy <- leafletProxy(ns("hydro_map")) |>
        hideGroup(c("Adults", "Eggs and Larvae", "Non-Migratory Juveniles")) |>
        showGroup("Study Area")
      if (input$habitat_layer != "Study Area") {
        proxy <- proxy |> showGroup(input$habitat_layer)
      }
    }, ignoreInit = TRUE)
    
    # HSI curve helper
    make_si_plotly <- function(df, x_col, x_label) {
      stopifnot(x_col %in% names(df), "SuitabilityIndex" %in% names(df))
      
      p <- ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_col]], y = SuitabilityIndex)) +
        ggplot2::geom_line(linewidth = 1) +
        ggplot2::geom_point(size = 1.5) +
        ggplot2::scale_y_continuous(limits = c(0, 1), breaks = c(0, 0.5, 1)) +
        ggplot2::labs(x = x_label, y = "HSI") +
        ggplot2::theme_minimal(base_family = "Arial") +
        ggplot2::theme(
          plot.margin = grid::unit(c(4, 10, 4, 10), "pt"),
          axis.title.x = ggplot2::element_text(size = 10),
          axis.title.y = ggplot2::element_text(size = 10),
          axis.text = ggplot2::element_text(size = 9)
        )
      
      plotly::ggplotly(p, tooltip = c(x_col, "SuitabilityIndex")) |>
        plotly::layout(margin = list(l = 45, r = 10, t = 5, b = 35))
    }
    
    # Adults
    output$adult_depth_plot <- plotly::renderPlotly({ make_si_plotly(adult_alewife_depth_suitability_data, "Depth", "Depth (m)") })
    output$adult_temp_plot  <- plotly::renderPlotly({ make_si_plotly(adult_alewife_temp_suitability_data, "Temperature", "Temperature (\u00b0C)") })
    output$adult_sal_plot   <- plotly::renderPlotly({ make_si_plotly(adult_alewife_salinity_suitability_data, "Salinity", "Salinity (ppt)") })
    output$adult_vel_plot   <- plotly::renderPlotly({ make_si_plotly(adult_alewife_velocity_suitability_data, "Velocity", "Velocity (m/s)") })
    
    # Eggs and Larvae
    output$eggs_depth_plot <- plotly::renderPlotly({ make_si_plotly(alewife_eggs_depth_suitability_data, "Depth", "Depth (m)") })
    output$eggs_temp_plot  <- plotly::renderPlotly({ make_si_plotly(alewife_eggs_temp_suitability_data, "Temperature", "Temperature (\u00b0C)") })
    output$eggs_sal_plot   <- plotly::renderPlotly({ make_si_plotly(alewife_eggs_salinity_suitability_data, "Salinity", "Salinity (ppt)") })
    output$eggs_vel_plot   <- plotly::renderPlotly({ make_si_plotly(alewife_eggs_velocity_suitability_data, "Velocity", "Velocity (m/s)") })
    
    # Juveniles
    output$juv_depth_plot <- plotly::renderPlotly({ make_si_plotly(juvenile_alewife_depth_suitability_data, "Depth", "Depth (m)") })
    output$juv_temp_plot  <- plotly::renderPlotly({ make_si_plotly(juvenile_alewife_temp_suitability_data, "Temperature", "Temperature (\u00b0C)") })
    output$juv_sal_plot   <- plotly::renderPlotly({ make_si_plotly(juvenile_alewife_salinity_suitability_data, "Salinity", "Salinity (ppt)") })
    output$juv_vel_plot   <- plotly::renderPlotly({ make_si_plotly(juvenile_alewife_velocity_suitability_data, "Velocity", "Velocity (m/s)") })
    
    # ---- Layer key helper ----
    `%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x
    
    # Group names for co-occurrence raster layers on map 2
    cooccur_groups <- c("Adults", "Eggs and Larvae", "Non-Migratory Juveniles", "All Life Stages")
    
    # -----------------------------
    # Risk Map (second map) — co-occurrence rasters
    # -----------------------------
    output$hydro_map_1 <- renderLeaflet({
      
      rng_hg   <- terra::global(r_mercury_ll, range, na.rm = TRUE)[1, ]
      rng_mehg <- terra::global(r_methylmercury_ll, range, na.rm = TRUE)[1, ]
      
      pal_hg <- leaflet::colorNumeric(
        palette = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
        domain  = rng_hg, na.color = "transparent"
      )
      pal_mehg <- leaflet::colorNumeric(
        palette = rev(RColorBrewer::brewer.pal(11, "RdYlGn")),
        domain  = rng_mehg, na.color = "transparent"
      )
      
      leaflet() |>
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldTerrain, group = "Terrain") |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
        
        # Study domain outline for context
        addPolygons(
          data = study_sf, group = "domain",
          color = "#444444", weight = 1.5, fillOpacity = 0, opacity = 0.7,
          dashArray = "5, 5"
        ) |>
        
        # Per-life-stage IF-HI co-occurrence rasters (0-7 months scale)
        addRasterImage(r_cooccur_adult_ll, colors = pal_cooccur, opacity = 0.85,
                       project = FALSE, group = "Adults") |>
        addRasterImage(r_cooccur_eggs_ll,  colors = pal_cooccur, opacity = 0.85,
                       project = FALSE, group = "Eggs and Larvae") |>
        addRasterImage(r_cooccur_juv_ll,   colors = pal_cooccur, opacity = 0.85,
                       project = FALSE, group = "Non-Migratory Juveniles") |>
        
        # Cross-life-stage summary raster (1-3 life stages)
        addRasterImage(r_n_stages_ll, colors = pal_n_stages, opacity = 0.85,
                       project = FALSE, group = "All Life Stages") |>
        
        # Show Adults by default; hide others
        hideGroup(c("Eggs and Larvae", "Non-Migratory Juveniles", "All Life Stages")) |>
        
        # Optional overlays
        addRasterImage(r_mercury_ll,       colors = pal_hg,   opacity = 0.65,
                       project = FALSE, group = "Mercury (THg)") |>
        addRasterImage(r_methylmercury_ll, colors = pal_mehg, opacity = 0.65,
                       project = FALSE, group = "Methylmercury (MeHg)") |>
        
        addAwesomeMarkers(data = dams, lng = ~lng, lat = ~lat, icon = dam_icon,
                          label = ~name,
                          popup = ~paste0("<b>", name, "</b><br/>Status: ", status),
                          group = "Dams") |>
        addAwesomeMarkers(data = pollution, lng = ~lng, lat = ~lat,
                          icon = pollution_icon, label = ~name,
                          popup = ~paste0("<b>", name, "</b><br/>", role),
                          group = "Pollution Sources") |>
        
        addLayersControl(
          baseGroups = c("Light", "Terrain", "Satellite"),
          overlayGroups = c("Mercury (THg)", "Methylmercury (MeHg)", "Dams", "Pollution Sources"),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        
        # Co-occurrence legend (1-7 months, per-stage layers)
        addLegend(pal = pal_cooccur, values = 1:7,
                  title = "IF-HI Co-occurrence<br>Months",
                  opacity = 1, position = "bottomleft",
                  layerId = "legend_cooccur") |>
        
        addLegend(pal = pal_hg,
                  values = seq(rng_hg[[1]], rng_hg[[2]], length.out = 7),
                  title = "Total Mercury (THg)", opacity = 1,
                  group = "Mercury (THg)", position = "bottomright") |>
        addLegend(pal = pal_mehg,
                  values = seq(rng_mehg[[1]], rng_mehg[[2]], length.out = 7),
                  title = "Methylmercury (MeHg)", opacity = 1,
                  group = "Methylmercury (MeHg)", position = "bottomright") |>
        
        hideGroup(c("Mercury (THg)", "Methylmercury (MeHg)")) |>
        fitBounds(
          lng1 = min(terra::ext(r_cooccur_juv_ll)$xmin, terra::ext(r_cooccur_adult_ll)$xmin),
          lat1 = min(terra::ext(r_cooccur_juv_ll)$ymin, terra::ext(r_cooccur_adult_ll)$ymin),
          lng2 = max(terra::ext(r_cooccur_juv_ll)$xmax, terra::ext(r_cooccur_adult_ll)$xmax),
          lat2 = max(terra::ext(r_cooccur_juv_ll)$ymax, terra::ext(r_cooccur_adult_ll)$ymax)
        )
    })
    
    # Checkbox drives which co-occurrence layer is visible; swaps legend too
    observeEvent(input$show_cooccur, {
      req(input$show_cooccur)
      sel <- input$show_cooccur
      
      proxy <- leafletProxy(ns("hydro_map_1")) |>
        hideGroup(cooccur_groups)
      
      for (grp in sel) proxy <- proxy |> showGroup(grp)
      
      # swap legend: show n-stages legend when "All Life Stages" is selected
      # and per-stage legend otherwise
      if ("All Life Stages" %in% sel && length(sel) == 1) {
        proxy <- proxy |>
          removeControl("legend_cooccur") |>
          addLegend(pal = pal_n_stages, values = 1:3,
                    title = "Life Stages with<br>Co-occurrence",
                    opacity = 1, position = "bottomleft",
                    layerId = "legend_cooccur")
      } else {
        proxy <- proxy |>
          removeControl("legend_cooccur") |>
          addLegend(pal = pal_cooccur, values = 1:7,
                    title = "IF-HI Co-occurrence<br>Months",
                    opacity = 1, position = "bottomleft",
                    layerId = "legend_cooccur")
      }
    }, ignoreInit = TRUE)
    
    # -----------------------------
    # Latitude profile helpers
    # -----------------------------
    story_layer_sf <- list(
      impact = list(
        adult                 = if_adults_sf,
        egg_larvae            = if_eggs_sf,
        nonmigratory_juvenile = if_juv_sf
      ),
      impairment = list(
        adult                 = hi_adults_sf,
        egg_larvae            = hi_eggs_sf,
        nonmigratory_juvenile = hi_juv_sf
      )
    )
    
    story_input_keys <- c(
      adults    = "adult",
      eggs      = "egg_larvae",
      juveniles = "nonmigratory_juvenile"
    )
    
    normalize_stage_selection <- function(sel) {
      if (is.null(sel) || length(sel) == 0) sel <- "adults"
      sel
    }
    
    get_combined_bbox <- function(sf_list) {
      sf_list <- Filter(Negate(is.null), sf_list)
      if (length(sf_list) == 0) return(NULL)
      bbs  <- lapply(sf_list, sf::st_bbox)
      xmin <- min(vapply(bbs, function(x) unname(x["xmin"]), numeric(1)), na.rm = TRUE)
      xmax <- max(vapply(bbs, function(x) unname(x["xmax"]), numeric(1)), na.rm = TRUE)
      ymin <- min(vapply(bbs, function(x) unname(x["ymin"]), numeric(1)), na.rm = TRUE)
      ymax <- max(vapply(bbs, function(x) unname(x["ymax"]), numeric(1)), na.rm = TRUE)
      c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)
    }
    
    story_map_bounds <- reactive({
      b <- input$hydro_map_1_bounds
      if (!is.null(b) && !is.null(b$west)) {
        list(west = b$west, east = b$east, south = b$south, north = b$north)
      } else {
        bb <- get_combined_bbox(c(story_layer_sf$impact, story_layer_sf$impairment))
        list(west = unname(bb["xmin"]), east = unname(bb["xmax"]),
             south = unname(bb["ymin"]), north = unname(bb["ymax"]))
      }
    })
    
    story_lat_range <- reactive({
      b <- story_map_bounds()
      c(b$south, b$north)
    })
    
    build_vertical_profile_single <- function(sf_obj, bounds, n_bins = 140) {
      if (is.null(sf_obj) || nrow(sf_obj) == 0) return(NULL)
      sf_obj <- sf::st_make_valid(sf_obj)
      bb <- sf::st_bbox(c(xmin = bounds$west, xmax = bounds$east,
                          ymin = bounds$south, ymax = bounds$north),
                        crs = sf::st_crs(sf_obj))
      sf_clip <- tryCatch(suppressWarnings(sf::st_crop(sf_obj, bb)), error = function(e) NULL)
      if (is.null(sf_clip) || nrow(sf_clip) == 0) return(NULL)
      
      lat_breaks <- seq(bounds$south, bounds$north, length.out = n_bins)
      
      out <- lapply(seq_len(length(lat_breaks) - 1), function(i) {
        y0 <- lat_breaks[i]; y1 <- lat_breaks[i + 1]
        band_bb <- sf::st_bbox(c(xmin = bounds$west, xmax = bounds$east,
                                 ymin = y0, ymax = y1),
                               crs = sf::st_crs(sf_clip))
        band_sf <- sf::st_sf(geometry = sf::st_as_sfc(band_bb))
        inter <- tryCatch(suppressWarnings(sf::st_intersection(sf_clip, band_sf)),
                          error = function(e) NULL)
        area_val <- if (is.null(inter) || nrow(inter) == 0) 0 else
          sum(as.numeric(sf::st_area(inter)), na.rm = TRUE)
        data.frame(lat = mean(c(y0, y1)), value = area_val)
      })
      
      prof <- dplyr::bind_rows(out) |>
        dplyr::mutate(value = ifelse(is.finite(value), value, 0))
      
      max_val <- max(prof$value, na.rm = TRUE)
      if (!is.finite(max_val) || max_val <= 0) return(NULL)
      
      prof |>
        dplyr::mutate(
          value_scaled = value / max_val,
          value_low    = pmax(value_scaled - 0.06, 0),
          value_high   = pmin(value_scaled + 0.06, 1)
        )
    }
    
    build_profile_collection <- function(selected_keys, metric_type, bounds) {
      selected_keys <- normalize_stage_selection(selected_keys)
      stage_keys    <- unname(story_input_keys[selected_keys])
      stage_keys    <- stage_keys[!is.na(stage_keys)]
      
      prof_list <- lapply(stage_keys, function(stage_key) {
        sf_obj <- story_layer_sf[[metric_type]][[stage_key]]
        prof   <- build_vertical_profile_single(sf_obj, bounds = bounds)
        if (is.null(prof) || nrow(prof) == 0) return(NULL)
        prof$LifeStage <- stage_key
        prof
      })
      
      prof_list <- Filter(Negate(is.null), prof_list)
      if (length(prof_list) == 0) return(NULL)
      dplyr::bind_rows(prof_list)
    }
    
    # Profile reactives — map checkbox selection to profile stage keys.
    # "All Life Stages" shows all three; individual choices show only those selected.
    cooccur_to_profile_keys <- function(sel) {
      key_map <- c(
        "Adults"                  = "adults",
        "Eggs and Larvae"         = "eggs",
        "Non-Migratory Juveniles" = "juveniles"
      )
      if ("All Life Stages" %in% sel) {
        return(c("adults", "eggs", "juveniles"))
      }
      profile_sel <- unname(key_map[sel[sel %in% names(key_map)]])
      if (length(profile_sel) == 0) profile_sel <- "adults"
      profile_sel
    }
    
    impact_profile_data <- reactive({
      build_profile_collection(
        cooccur_to_profile_keys(input$show_cooccur %||% "Adults"),
        "impact", story_map_bounds()
      )
    })
    
    impairment_profile_data <- reactive({
      build_profile_collection(
        cooccur_to_profile_keys(input$show_cooccur %||% "Adults"),
        "impairment", story_map_bounds()
      )
    })
    
    make_story_vertical_profile <- function(prof, x_title) {
      validate(need(!is.null(prof) && nrow(prof) > 0,
                    "No visible profile for the selected layer(s) in the current map extent."))
      
      lat_rng <- story_lat_range()
      p <- plotly::plot_ly()
      
      for (stg in unique(as.character(prof$LifeStage))) {
        d   <- prof[prof$LifeStage == stg, , drop = FALSE]
        col <- lifestage_colors[[stg]]
        lbl <- life_stage_labels[[stg]]
        
        p <- p |>
          plotly::add_trace(
            x = c(d$value_low, rev(d$value_high)),
            y = c(d$lat, rev(d$lat)),
            type = "scatter", mode = "lines", fill = "toself",
            fillcolor = grDevices::adjustcolor(col, alpha.f = 0.18),
            line = list(color = "transparent"),
            hoverinfo = "skip", showlegend = FALSE, legendgroup = stg
          ) |>
          plotly::add_trace(
            data = d, x = ~value_scaled, y = ~lat,
            type = "scatter", mode = "lines",
            name = lbl, legendgroup = stg, showlegend = TRUE,
            line = list(color = col, width = 3),
            hovertemplate = paste0("<b>", lbl, "</b><br>Latitude: %{y:.4f}<br>",
                                   x_title, ": %{x:.3f}<extra></extra>")
          )
      }
      
      dam_shapes <- lapply(seq_len(nrow(dams)), function(i) {
        list(type = "line", x0 = 0, x1 = 1, xref = "paper",
             y0 = dams$lat[i], y1 = dams$lat[i], yref = "y",
             line = list(color = "gray", dash = "dot", width = 1))
      })
      
      p |>
        plotly::layout(
          margin = list(t = 10, r = 10, b = 90, l = 65),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          xaxis = list(title = x_title, zeroline = FALSE,
                       range = c(0, 1.02), tickformat = ".1f"),
          yaxis = list(title = "Latitude", range = lat_rng,
                       tickformat = ".3f", fixedrange = TRUE),
          legend = list(
            orientation = "v",
            x           = 1.02,
            xanchor     = "left",
            y           = 0.5,
            yanchor     = "middle",
            font        = list(color = "#0f1f2d", size = 10),
            bgcolor     = "rgba(255,255,255,0)"
          ),
          margin = list(t = 10, r = 90, b = 30, l = 65),
          shapes = dam_shapes, hovermode = "closest",
          hoverlabel = list(bgcolor = "white", font = list(color = "black"))
        ) |>
        plotly::config(displaylogo = FALSE)
    }
    
    output$impact_vertical <- renderPlotly({
      make_story_vertical_profile(impact_profile_data(), "Relative Impact Density")
    })
    
    output$impairment_vertical <- renderPlotly({
      make_story_vertical_profile(impairment_profile_data(), "Relative Impairment Density")
    })
    
    
    # -----------------------
    # Cumulative Bar Plot
    # Updated: adults + juveniles only (eggs/larvae = 0, excluded per new results)
    # Values from Table 3.3 / Figure 3.10:
    #   Adults:    Exposure Intensity = 10.78 km2,  Impaired Habitat = 33.35 km2
    #   Juveniles: Exposure Intensity = 51.93 km2,  Impaired Habitat = 1867.11 km2
    # -----------------------
    cumulative_data_hardcoded <- data.frame(
      LifeStage = factor(
        c("adult", "adult", "nonmigratory_juvenile", "nonmigratory_juvenile"),
        levels = life_stage_levels
      ),
      Metric = factor(
        c("Exposure Intensity", "Impaired Habitat", "Exposure Intensity", "Impaired Habitat"),
        levels = c("Exposure Intensity", "Impaired Habitat")
      ),
      CumulativeValue = c(10.78, 33.35, 51.93, 1867.11)
    )
    
    make_cumulative_plot <- function(dat) {
      dat$LifeStage <- factor(dat$LifeStage, levels = life_stage_levels)
      dat$Metric    <- factor(dat$Metric, levels = c("Exposure Intensity", "Impaired Habitat"))
      
      ggplot2::ggplot(dat, ggplot2::aes(x = Metric, y = CumulativeValue, fill = LifeStage)) +
        ggplot2::geom_col(
          position = ggplot2::position_dodge2(width = 0.82, preserve = "single"),
          width = 0.55, color = "#ffffff", linewidth = 0.3
        ) +
        ggplot2::scale_fill_manual(
          values = lifestage_colors,
          breaks = life_stage_levels,
          labels = life_stage_labels,
          name = NULL
        ) +
        ggplot2::scale_y_continuous(
          labels = scales::label_comma(),
          expand = ggplot2::expansion(mult = c(0, 0.06))
        ) +
        ggplot2::labs(x = NULL, y = "Cumulative Value (area-weighted km\u00b2)") +
        ggplot2::theme_minimal(base_size = 16) +
        ggplot2::theme(
          plot.background  = ggplot2::element_rect(fill = "transparent", color = NA),
          panel.background = ggplot2::element_rect(fill = "transparent", color = NA),
          text         = ggplot2::element_text(color = "#ffffff"),
          axis.text.x  = ggplot2::element_text(size = 16, color = "#ffffff"),
          axis.text.y  = ggplot2::element_text(size = 16, color = "#ffffff"),
          axis.title.y = ggplot2::element_text(size = 16, color = "#ffffff",
                                               margin = ggplot2::margin(r = 10)),
          panel.grid.minor   = ggplot2::element_blank(),
          panel.grid.major.x = ggplot2::element_blank(),
          panel.grid.major.y = ggplot2::element_line(color = "#ffffff", linewidth = 0.35),
          legend.position = "none",
          plot.margin = ggplot2::margin(12, 14, 12, 14)
        )
    }
    
    output$cumulative_plot <- plotly::renderPlotly({
      # Use CSV data if available; fall back to hardcoded values from Table 3.3
      dat <- tryCatch(
        {
          d <- seasonal_cum_long |>
            dplyr::filter(LifeStage != "egg_larvae")  # remove eggs/larvae (no HSI > 0.8)
          if (nrow(d) == 0) stop("empty")
          d
        },
        error = function(e) cumulative_data_hardcoded
      )
      
      p <- make_cumulative_plot(dat)
      
      plotly::ggplotly(p, tooltip = c("x", "y", "fill")) |>
        plotly::layout(
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font = list(color = "#ffffff"),
          xaxis = list(color = "#ffffff", tickfont = list(color = "#ffffff"),
                       titlefont = list(color = "#ffffff"), zeroline = FALSE),
          yaxis = list(color = "#ffffff", tickfont = list(color = "#ffffff"),
                       titlefont = list(color = "#ffffff"), gridcolor = "#ffffff", zeroline = FALSE),
          margin = list(l = 60, r = 10, t = 10, b = 60),
          showlegend = FALSE
        ) |>
        plotly::config(responsive = TRUE)
    })
    
    # -----------------------------
    # Persistent hotspot capture pie charts
    # Updated values from Table 3.3:
    #   Adults:    elevated footprint = 8.54 km2, hotspot = 3.67 km2 (43%)
    #   Eggs:      elevated footprint = 0.009 km2 (use ~0.01), hotspot = 0.009 km2 (100%)
    #   Juveniles: elevated footprint = 14.70 km2, hotspot = 3.67 km2 (25%)
    # -----------------------------
    make_hotspot_capture_pie <- function(stage_title, elevated, hotspot) {
      hotspot   <- min(hotspot, elevated)
      remaining <- max(elevated - hotspot, 0)
      
      plotly::plot_ly(
        labels = c("Persistent Risk Hotspot", "Remaining Elevated Risk"),
        values = c(hotspot, remaining),
        type   = "pie",
        marker = list(
          colors = c("#4CAF50", "#FF9800"),
          line   = list(color = "rgba(255,255,255,0.35)", width = 1)
        ),
        textinfo     = "label+percent",
        textposition = "outside",
        textfont     = list(color = "#E6E6E6", size = 13),
        hoverinfo    = "label+value+percent",
        sort         = FALSE
      ) |>
        plotly::layout(
          title = list(
            text = stage_title,
            font = list(color = "#E6E6E6", size = 16, family = "Arial Black"),
            pad  = list(b = 24)
          ),
          font = list(color = "#E6E6E6"),
          showlegend = TRUE,
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center", y = -0.32,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)", bordercolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 85, b = 115, l = 35, r = 35),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        ) |>
        plotly::config(displaylogo = FALSE)
    }
    
    # Adults: 8.54 km2 elevated, 3.67 km2 hotspot (43%)
    output$pie_adult_hotspot <- plotly::renderPlotly({
      make_hotspot_capture_pie("Adult", elevated = 8540000, hotspot = 3670000)
    })
    
    # Eggs & Larvae: 0.009 km2 elevated, 0.009 km2 hotspot (100%)
    output$pie_egg_hotspot <- plotly::renderPlotly({
      make_hotspot_capture_pie("Egg and Larvae", elevated = 9000, hotspot = 9000)
    })
    
    # Non-Migratory Juveniles: 14.70 km2 elevated, 3.67 km2 hotspot (25%)
    output$pie_juvenile_hotspot <- plotly::renderPlotly({
      make_hotspot_capture_pie("Non-Migratory Juveniles", elevated = 14700000, hotspot = 3670000)
    })
    
    
    return(list(selected_stage = selected))
    
  })
}