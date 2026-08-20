# =============================================================================
# tab_behavioral_risk_ui() + tab_behavioral_risk_server()
# Penobscot Mercury Exposure Model (P-MEM) — Chapter 4
# Matches the style/structure of tab_hydrodynamics_*()
# =============================================================================

# ---- helper: scenario colour palette ----------------------------------------
scenario_cols <- c(
  "None"     = "#4D9DE0",
  "Low"      = "#E15554",
  "Baseline" = "#3BB273",
  "High"     = "#F4A259"
)

scenario_levels <- c("None", "Low", "Baseline", "High")

# =============================================================================
# UI
# =============================================================================

tab_behavioral_risk_ui <- function(id = "behavior") {
  ns <- NS(id)
  
  tabPanel(
    title = "Behavior-Mediated Risk",
    value = "behavior",
    
    fluidPage(
      
      # ---- INTRO / HERO -------------------------------------------------------
      div(
        class = "home-intro",
        
        fluidRow(
          column(12,
                 div(class = "hero-header",
                     h1("Behavior as a Driver of Contaminant Exposure",
                        class = "hero-title hero-title-overlay")
                 )
          )
        ),
        
        # ---- Glossary button --------------------------------------------------
        actionButton(ns("toggle_glossary"), "Glossary", class = "glossary-btn"),
        
        div(
          id    = ns("glossary_tab"),
          class = "glossary-tab",
          h3("Glossary"),
          tags$hr(),
          tags$dl(
            tags$dt("Alewife"),
            tags$dd("A species of river herring that migrates from the ocean into rivers and lakes to spawn. In the Penobscot system, alewives use the estuary as a migration corridor and staging area."),
            tags$dt("Anadromous Fish"),
            tags$dd("Fish species that migrate between marine and freshwater environments as part of their life cycle."),
            tags$dt("Agent-Based Model (ABM)"),
            tags$dd("A computational model in which individual organisms (agents) follow state-dependent behavioral rules, producing emergent population-level patterns from the bottom up."),
            tags$dt("Behavioral State"),
            tags$dd("The mode of activity an individual fish is engaged in at a given moment, such as directed migration, foraging, schooling, or resting, which governs contaminant exposure pathway and intensity."),
            tags$dt("Bioaccumulation"),
            tags$dd("The buildup of contaminants within an individual organism over time as uptake exceeds elimination."),
            tags$dt("Biomagnification"),
            tags$dd("The increase in contaminant concentration at higher trophic levels as predators consume contaminated prey."),
            tags$dt("Contaminant Exposure Pathway"),
            tags$dd("The specific route through which a contaminant is internalized, including gill uptake, particulate ingestion, or trophic (predator–prey) transfer."),
            tags$dt("Estuarine Turbidity Maximum (ETM)"),
            tags$dd("A circulation-driven zone of suspended particulate matter (SPM) retention that forms near the landward limit of salt intrusion, concentrating contaminants at a key migration bottleneck."),
            tags$dt("Gill Uptake"),
            tags$dd("Passive absorption of dissolved or particulate contaminants across gill surfaces during respiratory water flow. Dominant exposure pathway for obligate migrants like alewives."),
            tags$dt("GoFish Library"),
            tags$dd("A co-developed, modular, open-source toolkit of standardized behavioral submodels for anadromous fish, used as the behavioral engine within P-MEM."),
            tags$dt("Methylmercury (MeHg)"),
            tags$dd("An organic, bioavailable form of mercury produced by microbial methylation in low-oxygen sediments. Readily biomagnifies through food webs."),
            tags$dt("Migration Cue"),
            tags$dd("An environmental signal — such as a coincident decline in temperature and photoperiod — that triggers the transition from pre-migration dormancy to directed movement."),
            tags$dt("Net Realized Risk"),
            tags$dd("The cumulative contaminant burden accumulated by an individual fish through all active exposure pathways over the course of migration."),
            tags$dt("P-MEM"),
            tags$dd("The Penobscot Mercury Exposure Model — a coupled hydrodynamic–agent-based model that quantifies behaviorally mediated MeHg exposure for anadromous fish in the Penobscot River Estuary."),
            tags$dt("Predation Scenario"),
            tags$dd("A controlled model experiment varying predator detection distance and encounter pressure while holding population structure and environmental forcing constant."),
            tags$dt("Realized Exposure"),
            tags$dd("The actual contaminant dose internalized by an organism, which depends on behavioral state, physiological condition, and interaction with contaminated material — not merely spatial co-occurrence."),
            tags$dt("Selective Tidal Stream Transport (STST)"),
            tags$dd("A behavioral strategy in which fish selectively move during favorable tidal phases to reduce energetic cost and maximize upstream or downstream displacement."),
            tags$dt("Striped Bass"),
            tags$dd("A facultative seasonal forager that uses the estuary opportunistically to exploit prey aggregations. Unlike alewives, striped bass accumulate MeHg primarily through trophic ingestion of contaminated prey."),
            tags$dt("Trophic Transfer"),
            tags$dd("Contaminant uptake via consumption of contaminated prey, which can amplify exposure orders of magnitude above environmental concentrations through biomagnification."),
            tags$dt("Suspended Particulate Matter (SPM)"),
            tags$dd("Fine sediment and organic particles suspended in the water column. SPM is the primary transport vector for mercury in estuaries and a critical medium of contaminant exposure for fish through gill contact and filter feeding."),
            tags$dt("Mercury (Hg)"),
            tags$dd("A toxic heavy metal introduced into the Penobscot River Estuary by the former HoltraChem facility. Inorganic mercury stored in estuarine sediments is the precursor for microbial methylation into the more bioavailable and toxic methylmercury form."),
            tags$dt("Exposure Potential"),
            tags$dd("The likelihood that an organism will encounter biologically available contamination, determined by where and when contaminated SPM is present. Exposure potential is a property of the environment — distinct from realized exposure, which depends on what the organism is doing at a given time and place."),
            tags$dt("Effects Range Low (ERL)"),
            tags$dd("A sediment quality guideline defining the concentration below which adverse biological effects are rarely observed. For MeHg, the ERL is 15 ng/g and is used in P-MEM to contextualize exposure duration relative to established biological thresholds.")
          )
        ),
        
        # JS glossary toggle (module-safe)
        tags$script(HTML(sprintf("
(function() {
  function bindGlossaryToggle() {
    var btn   = document.getElementById('%s');
    var panel = document.getElementById('%s');
    if (!btn || !panel) return;
    if (btn.dataset.bound === 'true') return;
    btn.dataset.bound = 'true';
    btn.addEventListener('click', function() { panel.classList.toggle('open'); });
  }
  document.addEventListener('DOMContentLoaded', bindGlossaryToggle);
  if (window.Shiny) {
    Shiny.addCustomMessageHandler('rebind_glossary_abm', function(_) { bindGlossaryToggle(); });
  }
  setTimeout(bindGlossaryToggle, 0);
})();
", ns("toggle_glossary"), ns("glossary_tab")))),
        
        # ---- Intro Section ------------------------------------------------
        fluidRow(
          column(
            width = 10,
            offset = 1,
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
                  h3("Overview", class = "tile-title", style = "text-align:center;"),
                  p(
                    "This section applies the Penobscot Mercury Exposure Model (P-MEM), a coupled hydrodynamic-agent-based modeling framework, to examine how methylmercury exposure emerges for alewives and striped bass within the Penobscot River Estuary. Rather than treating exposure as a fixed environmental condition, P-MEM represents it as the result of repeated interactions between individual movement, energetic demand, foraging behavior, predator-prey encounters, and spatially variable contaminant fields.",
                    style = "text-align:center;"
                  ),
                  p(
                    "The hydrodynamic simulation is derived from a hydrodynamic model of the 2023 field season (Nalika Lakmali), calibrated and validated using observations collected at the Bangor and Hampden field sites. These data constrain key processes including flow magnitude, tidal timing, salinity structure, and material transport, ensuring that modeled contaminant fields reflect observed estuarine dynamics. This grounding in field-based hydrodynamics allows P-MEM to resolve how physical transport processes shape the spatial and temporal structure of exposure opportunities across the estuary.",
                    style = "text-align:center;"
                  ),
                  p(
                    "Within this dynamic hydrodynamic landscape, alewives and striped bass follow different behavioral pathways that determine how exposure opportunity is converted into realized risk through direct interaction with contamination. While hydrodynamics and contaminant distributions define where exposure is possible, simulated exposure occurs only when modeled individuals occupy, forage within, or move through these contaminated regions. Simulated alewives migrate through the estuary according to the behavioral rules represented in P-MEM and convert exposure opportunity into simulated risk through gill contact, particulate ingestion, and repeated transit across contaminated habitat, whereas striped bass occupy the estuary more opportunistically and convert exposure through localized foraging, movement, and trophic interactions with prey. By linking modeled hydrodynamics, methylmercury distributions, and species-specific behavioral rules, this section identifies how behavioral interactions transform spatial exposure potential into realized mercury exposure across time and space for both species.",
                    style = "text-align:center;"
                  )
                )
              )
            )
          )
        ),
        
        div(class = "section-space"),
        
        # ---- Conceptual Risk: text left, figure right ----------------------
        fluidRow(
          column(
            5,
            h3("Behavior Converts Exposure Opportunity into Risk", class = "tile-title",
               style = "text-align:center;"),
            div(class = "section-space-small"),
            p(
              "Exposure opportunity alone does not determine realized risk. Instead, risk depends on how modeled individuals interact with contamination through different behavioral pathways. During directed migration, exposure is lowest and occurs primarily through brief gill contact with contaminated water. As fish begin particulate feeding, risk increases due to more frequent contact with and ingestion of contaminated suspended material. Within the model, the highest simulated exposure is associated with predation, when fish consume contaminated prey and accumulate mercury through trophic transfer.",
              class = "helper-text"
            ),
            p(
              "Within this system, hydrodynamics and contaminant distributions define where exposure is possible, but simulated exposure occurs only when modeled individuals occupy and interact with these regions. Migration timing, behavioral state, and life stage determine whether fish are simply passing through contaminated water or actively engaging with it through feeding and trophic interactions, making exposure episodic and seasonally constrained.",
              class = "helper-text"
            ),
            p(
              "As fish transition among behavioral states, the magnitude of exposure changes accordingly. Low risk is associated with brief transit through contaminated water, moderate risk emerges with particulate feeding, and high risk results from trophic predation. Because these behaviors can occur within the same location, individuals occupying identical environmental conditions may experience very different levels of exposure.",
              class = "helper-text"
            )
          ),
          column(
            7,
            div(
              tags$figure(
                class = "hero-figure",
                tags$img(
                  src   = "Figure_4B1_Risk_Con_Fig.png",
                  alt   = "Conceptual framework: behaviorally mediated contaminant exposure pathways",
                  style = "width:60%; border-radius:2px;"
                ),
                tags$figcaption(
                  "Conceptual framework illustrating how behavior converts exposure opportunity into realized risk. Exposure increases from directed migration (gill contact), to particulate feeding, to trophic predation.",
                  class = "hero-figure-caption"
                )
              )
            )
          )
        ),
      
      div(class = "section-space"),
      
      # ---- P-MEM INTRO: sticky figure left, 3 stacked panels right ----------
      fluidRow(
        
        # LEFT: P-MEM conceptual figure — stays visible while user scrolls right panels
        column(
          4,
          div(
            style = "position: sticky; top: 20px;",
            tags$figure(
              class = "hero-figure",
              tags$img(
                src   = "Conceptual_Diagram_ABM.png",
                alt   = "P-MEM conceptual architecture",
                style = "width:100%; border-radius:8px;"
              ),
              tags$figcaption(
                "P-MEM workflow: the spatial domain of the Penobscot River Estuary from marine entry to upstream homing site, overlaid with MeHg concentrations. State-dependent processes executed at each time step include migration cue detection, metabolism, contaminant and salinity exposure, digestion, and movement.",
                class = "hero-figure-caption"
              )
            )
          )
        ),
        
        # RIGHT: three stacked panels
        column(
          8,
          
          # Panel 1 — Model Description
          card(
            class = "tile-pop",
            style = "margin-bottom: 18px;",
            card_body(
              h3("Model Description", class = "tile-title", style = "text-align:center;"),
              p(
                "The Penobscot Mercury Exposure Model (P-MEM) simulates how individual fish move through the estuary and accumulate contamination over time. Instead of treating fish as a single population, the model represents each fish as an individual that responds to tides, salinity, temperature, and prey availability while migrating through the system.",
                class = "helper-text"
              ),
              p(
                "This approach allows us to ask a different question than traditional models: not just where contamination is located, but how fish actually encounter it. Alewives, which must migrate upstream to spawn, accumulate exposure primarily through direct contact with contaminated water and suspended particles during migration. In contrast, striped bass accumulate exposure mainly through feeding on contaminated prey, linking their risk to predator–prey interactions rather than direct interaction with contaminated particles.",
                class = "helper-text"
              ),
              p(
                "By testing different predation levels, the model isolates how changes in behavior, can shift exposure pathways and overall risk levels within a population. This helps identify which processes drive exposure in migratory fish and which management actions may be most effective in reducing it.",
                class = "helper-text"
              )
            )
          ),
          
          # Panel 2 — Predation
          card(
            class = "tile-pop",
            style = "margin-bottom: 0; background-color: transparent; box-shadow: none; border: none;",
            card_body(
              style = "padding: 0;",
              div(
                class = "home-section-transparent",
                style = "margin-bottom: 0; padding-bottom: 0;",
                fluidRow(
                  column(
                    12,
                    h3("Predation Scenario Design", class = "tile-title",
                       style = "text-align: center;")
                  ),
                  div(class = "section-space-small"),
                  column(
                    12,
                    p(
                      "Four controlled scenarios vary predator detection distance while holding population structure and environmental forcing constant. This isolates the effect of behavioral encounter intensity on realized contaminant exposure. The baseline condition represents the empirically informed predator–prey interaction structure of the system, with detection distance (d₀) calibrated using observed predator–prey ratios and encounter dynamics from 2020 Maine Department of Marine Resources data together with model-derived movement behavior.",
                      class = "helper-text",
                      style = "text-align: center;"
                    ),
                    div(
                      class = "tile-white tile-pop",
                      style = "max-width: 800px; margin: 0 auto 8px auto;",
                      tags$table(
                        class = "table table-striped table-bordered",
                        style = "width: 100%; margin-bottom: 0px;",
                        tags$thead(
                          tags$tr(
                            tags$th("Scenario"),
                            tags$th("Detection Distance"),
                            tags$th("Alewives (Prey)"),
                            tags$th("Striped Bass (Predator)"),
                            tags$th("Description")
                          )
                        ),
                        tags$tbody(
                          tags$tr(
                            tags$td("No Predation"),
                            tags$td(HTML("0.0 &times; d<sub>0</sub>")),
                            tags$td("4,000"),
                            tags$td("4"),
                            tags$td("Minimum sensory detection — no effective predator–prey encounters")
                          ),
                          tags$tr(
                            tags$td("Low Predation"),
                            tags$td(HTML("0.5 &times; d<sub>0</sub>")),
                            tags$td("4,000"),
                            tags$td("4"),
                            tags$td("Reduced encounter pressure relative to baseline")
                          ),
                          tags$tr(
                            tags$td("Base Predation"),
                            tags$td(HTML("1.0 &times; d<sub>0</sub>")),
                            tags$td("4,000"),
                            tags$td("4"),
                            tags$td("Baseline detection distance calibrated to system conditions")
                          ),
                          tags$tr(
                            tags$td("High Predation"),
                            tags$td(HTML("2.0 &times; d<sub>0</sub>")),
                            tags$td("4,000"),
                            tags$td("4"),
                            tags$td("Doubled encounter pressure — elevated interaction intensity")
                          )
                        )
                      ),
                      tags$div(
                        class = "hero-figure-caption",
                        style = "text-align: center; margin-top: 6px; margin-bottom: 0; color: #0f1f2d !important;",
                        HTML(
                          "<b>Table 2.</b> Predation scenarios implemented in the Penobscot Mercury Exposure Model (P-MEM). Detection distance is scaled relative to the baseline sensory distance d<sub>0</sub>, modifying encounter pressure without altering predator or prey abundance. All scenarios hold population structure and environmental forcing constant."
                        )
                      )
                    )
                  )
                )
              )
            )
          ),
          
          div(class = "section-space"),
          
          # Panel 3 — Model Evaluation (tabbed: Alewife / Striped Bass)
          card(
            class = "tile-pop",
            style = "margin-top: 0;",
            card_body(
              style = "padding-top: 8px;",
              h3("Model Evaluation", class = "tile-title", style = "text-align:center; margin-top: 0; margin-bottom: 8px;"),
              tabsetPanel(
                id = ns("eval_tabs"),
                type = "tabs",
                
                # Tab 1: Alewife
                tabPanel(
                  "Alewife",
                  div(style = "padding-top:0px;",
                      fluidRow(
                        column(8, 
                               h3("Alewife: Simulated vs. Observed Passage", 
                                  class = "tile-title", 
                                  style = "text-align: center; margin-top: 12px; margin-bottom: 12px;"), 
                               p( "Observed daily fish lift counts at Milford Dam are compared to simulated upstream passage at a virtual fish lift positioned slightly downstream of Milford Dam within the model domain. In both observed and simulated data, migration initiates rapidly in early May, rises steeply to a single dominant peak, and declines sharply by mid-June, producing a unimodal seasonal passage pattern.", 
                                  class = "helper-text" ), 
                               p( "Across predation scenarios, the simulated migration pulse closely reproduces the shape, duration, and magnitude of observed passage. The simulated peak occurs slightly later than observed, within approximately 1 day, suggesting that modeled alewives progress upstream slightly more slowly than observed in the field. This small delay may increase residence time in exposure-relevant regions, with potential implications for cumulative MeHg exposure.", 
                                  class = "helper-text" ), 
                               p( "Model performance was consistent across predation scenarios, with mean R² values of approximately 0.63–0.64, correlations of 0.80, and low RMSE values. Predation intensity did not substantially alter migration timing or model agreement with observed passage, indicating that the modeled migration structure is robust to variation in predator encounter pressure.", 
                                  class = "helper-text" ), 
                               plotlyOutput(ns("plot_milford_eval"), 
                                            height = "360px"), 
                               tags$figcaption( "Observed daily fish lift counts at Milford Dam compared to simulated upstream passage at the virtual Milford Dam across predation scenarios. Gray bars represent observed daily passage, colored lines represent simulated daily passage, and the dashed vertical reference marks the observed peak passage date.", class = "hero-figure-caption", style = "text-align:center" ) ),
                        column(4,
                               div(
                                 class = "hydro-interpret-panel hydro-interpret-tile tile-pop",
                                 style = "background:rgba(240,240,240,0.82)!important;
                   color:#0f1f2d!important;
                   border-radius:16px!important;
                   border:1px solid rgba(15,31,45,0.12)!important;
                   padding:18px!important;
                   margin-top:60px;",
                                 h3("Evaluation Metrics", class = "tile-title",
                                    style = "color:#0f1f2d!important; margin-top: 12px; margin-bottom: 12px;"),
                                 p(
                                   "R\u00b2 values compare the normalized shape of the simulated migration
            pulse to observed Milford Dam fish lift counts. Values near 1 indicate
            strong agreement in seasonal timing and relative magnitude.",
                                   style = "color:#0f1f2d!important;"
                                 ),
                                 tableOutput(ns("milford_r2_table")),
                                 tags$figcaption(
                                   "Table 3. Modeled striped bass hunting probability as a function of temperature, salinity, and velocity gradients, demonstrating environmental filtering of predation behavior.",
                                   class = "hero-figure-caption",
                                   style = "color:#0f1f2d!important;"
                                 )
                               )
                        )
                      )
                  )
                ),
                
                # Tab 2: Striped Bass
                tabPanel( "Striped Bass", 
                          div(
                            style = "padding-top:0px;", 
                            h3("Striped Bass: Simulated Hunting Dynamics", 
                               class = "tile-title", 
                               style = "text-align: center; margin-top: 12px; margin-bottom: 12px;"), 
                            p( "Striped bass evaluation relied on structured expert elicitation because comparable fine-scale passage data are unavailable. Expert input indicated that seasonal cues are the dominant trigger for immigration and outmigration, with striped bass entering the estuary in late May to early June and departing in July, August, and October. This timing closely matches the simulated seasonal presence and exit patterns.", 
                               class = "helper-text" ), 
                            p( "Experts also emphasized that striped bass shift locally in response to prey availability rather than dispersing uniformly or remaining exclusively in upstream freshwater reaches. This is consistent with the model’s prey-following, patch-based residence, and foraging behavior. Modeled hunting probability is environmentally structured, increasing with temperature, declining strongly with salinity, and showing weaker sensitivity to velocity. This indicates that predation is environmentally filtered rather than occurring uniformly across the estuary.", 
                               class = "helper-text" ), 
                            p( "The primary divergence identified during evaluation is that simulated striped bass do not currently move into freshwater reaches near Milford Dam, where experts note that predators often aggregate to exploit concentrated prey. This difference reflects a structural limitation of the modeled domain rather than a behavioral misrepresentation. Because Milford Dam is outside the simulated domain and is not explicitly represented as a barrier, prey are not retained or concentrated below the dam, and predators cannot respond to an aggregation that does not form in the model.", 
                               class = "helper-text" ), 
                            p( "The current striped bass implementation also does not simulate learning, memory, or socially transmitted knowledge of productive foraging locations. As a result, the model reproduces environmentally mediated foraging and prey-following dynamics, but does not capture adaptive route restructuring based on prior experience. This limitation may underestimate localized predation intensity and associated exposure near upstream freshwater reaches.", 
                              class = "helper-text" ), 
                            p( "Within the modeled estuarine domain, striped bass function as a behaviorally realistic predator agent that structures system dynamics through predation pressure and prey encounter processes. The model should therefore be interpreted as resolving predator–prey interactions and exposure dynamics within the spatial bounds of the simulated landscape, rather than as a site-specific reconstruction of striped bass habitat use throughout the full Penobscot system.", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       class = "helper-text" ),
                      tags$figure(
                        class = "hero-figure",
                        fluidRow(
                          column(12,
                                 radioButtons(ns("hunt_prey"), "Prey Presence",
                                              choices  = c("Yes" = 1, "No" = 0),
                                              selected = 1,
                                              inline   = TRUE),
                                 style = "text-align: left;"
                          )
                        ),
                        fluidRow(
                          column(12,
                                 plotlyOutput(ns("plot_hunt_eval"), height = "420px")
                          )
                        ),
                        tags$figcaption(
                          "Modeled striped bass hunting probability as a function of temperature, salinity, and velocity gradients, demonstrating environmental filtering of predation behavior.",
                          class = "hero-figure-caption",
                          style = "text-align:center"
                        )
                      )
                  )
                )
                
              ) # /tabsetPanel
            )
          ) # /Panel 3
          
        ) # /column right
      ), # /fluidRow P-MEM intro
      
      div(class = "section-space"),
      
      # ---- ESTUARY ENTRY / EXIT TIME SERIES ----------------------------------
      div(
        class = "home-section-transparent",
        
        h3("Estuary Occupancy: Daily Entry and Exit Dynamics", class = "tile-title"),
        p("Select species to view the proportion of the simulated population entering or exiting the estuary per day, illustrating seasonal migration structure across predation scenarios.", class = "helper-text"),
        
        fluidRow(
          column(12,
                 radioButtons(ns("entry_species"), "Species",
                              choices  = c("Alewife" = "alewife", "Striped Bass" = "stripedbass"),
                              selected = "alewife",
                              inline   = TRUE)
          )
        ),
        
        fluidRow(
          column(8,
                 plotlyOutput(ns("plot_entry_exit"), height = "620px"),
                 tags$figcaption(
                   "Modeled striped bass hunting probability as a function of temperature, salinity, and velocity gradients, demonstrating environmental filtering of predation behavior.",
                   class = "hero-figure-caption",
                   style = "text-align:center"
                 )
          ),
          column(4,
                 div(class = "hydro-interpret-panel hydro-interpret-tile tile-pop",
                     style = "background:rgba(240,240,240,0.82)!important;
               color:#0f1f2d!important;
               border-radius:16px!important;
               border:1px solid rgba(15,31,45,0.12)!important;
               padding:10px!important;
               margin-top:-60px;",
                     h3("Interpreting Estuary Use Patterns", class = "tile-title",
                        style = "color:#0f1f2d!important;"),
                     p(
                       "Lines show the daily proportion of the simulated population entering (solid) or exiting (dashed) the estuary. Because fish can cross boundaries multiple times in a season, entry and exit alone do not represent true arrival and departure. To address this, movement direction (landward versus seaward) is shown alongside boundary crossings to clarify seasonal patterns.",
                       style = "color:#0f1f2d!important;"
                     ),
                     p(
                       "Alewives show a coordinated landward pulse beginning in early May, consistent with spring spawning migration. As the season progresses, entry and exit overlap as early fish begin moving downstream while others are still arriving. Peak daily movement remains low, about 1 to 4 percent of the population across scenarios, with similar timing and magnitude, indicating a stable and synchronized migration pattern.",
                       style = "color:#0f1f2d!important;"
                     ),
                     p(
                       "Striped bass enter later, from mid-May to early June, and stay in the estuary longer. Exit occurs intermittently through late summer and early fall rather than as a single pulse. Peak daily movement is much higher, reaching about 17 to 33 percent of the population depending on predation scenario, with differences in magnitude but similar seasonal timing.",
                       style = "color:#0f1f2d!important;"
                     ),
                     p(
                       "Being able to simulate these dynamics provides a way to link when and where fish are present in the system to when and where exposure can occur.",
                       style = "color:#0f1f2d!important;"
                     )
                 )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ---- MAP + VERTICAL LATITUDE PROFILE --------------------------------
      fluidRow(
        column(
          9,
          div(
            class = "hydro-map-wrap",
            style = "height: 600px; position: relative;",
            leafletOutput(ns("abm_map"), width = "100%", height = "600px"),
            
            div(
              class = "hydro-overlay-left",
              div(
                class = "overlay-section",
                h3("Penobscot River Estuary, ME", class = "tile-title"),
                p(
                  "The P-MEM simulates alewife and striped bass migration through the full estuarine corridor from marine entry to a representative upstream homing site. Use the controls to view methylmercury risk patterns, residence time, and pathway-specific exposure surfaces.",
                  class = "helper-text"
                ),
                selectInput(
                  ns("map_species"), "Species",
                  choices = c("Alewife" = "alewife", "Striped Bass" = "stripedbass"),
                  selected = "alewife"
                ),
                selectInput(
                  ns("map_metric"), "Risk Metric",
                  choices = c(
                    "Cumulative Realized Risk" = "cum_risk",
                    "Population Residence Time" = "residence",
                    "Gill Uptake Risk" = "gill",
                    "Foraging Risk" = "foraging"
                  ),
                  selected = "cum_risk"
                ),
                selectInput(
                  ns("map_scenario"), "Predation Scenario",
                  choices = c(
                    "No Predation" = "None",
                    "Low Predation" = "Low",
                    "Base Predation" = "Baseline",
                    "High Predation" = "High"
                  ),
                  selected = "None"
                )
              )
            )
          )
        ),
        
        column(
          3,
          div(
            class = "tile-white tile-pop",
            style = "height: 600px; padding: 12px; display: flex; flex-direction: column;",
            h3("Along-Estuary Risk Dynamics", class = "tile-title", style = "text-align:center; margin-top: 0;"),
            # p(
            #   "Latitude is plotted on the vertical axis to match the visible map extent.",
            #   class = "helper-text",
            #   style = "text-align:center; margin-bottom: 8px;"
            # ),
            div(
              style = "flex: 1; min-height: 0;",
              plotlyOutput(ns("plot_lat_profile_vertical"), height = "100%")
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ---- TEMPORAL ACCUMULATION TIME SERIES ---------------------------------
      div(
        class = "home-section-transparent",
        
        h3("Temporal Accumulation of Exposure Metrics During Migration", class = "tile-title"),
        p("Cumulative exposure metrics plotted over the migration season reveal how realized burden builds across predation scenarios. Select a species and metric to explore pathway-specific accumulation dynamics.", class = "helper-text"),
        
        fluidRow(
          column(12,
                 radioButtons(ns("ts_species"), "Species",
                              choices  = c("Alewife" = "alewife", "Striped Bass" = "stripedbass"),
                              selected = "alewife",
                              inline   = TRUE),
                 radioButtons(ns("ts_metric"), "Metric",
                              choices  = c("Net Realized Risk"    = "net_risk",
                                           "Exposure Duration"    = "duration",
                                           "Gill Uptake Risk"     = "gill",
                                           "Foraging Risk"        = "foraging"),
                              selected = "net_risk",
                              inline   = TRUE)
          )
        ),
        
        fluidRow(
          style = "display:flex; align-items:stretch;",
          
          column(
            8,
            style = "display:flex;",
            plotlyOutput(ns("plot_ts_risk"), height = "550px")
          ),
          column(
            4,
            style = "display:flex; align-items:flex-start;",
            div(
              class = "hydro-interpret-panel hydro-interpret-tile tile-pop",
              style = "width:100%;
             height:auto !important;
             min-height:0 !important;
             max-height:550px !important;
             overflow-y:auto;
             align-self:flex-start;
             background:rgba(240,240,240,0.82)!important;
             color:#0f1f2d!important;
             border-radius:16px!important;
             border:1px solid rgba(15,31,45,0.12)!important;
             padding:18px!important;
             margin-top:-20px;",
              h3("Risk Accumulation", class = "tile-title",
                 style = "color:#0f1f2d!important;"),
              uiOutput(ns("ts_interpret_text"))
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ---- PROPORTIONAL CONTRIBUTION OF EXPOSURE PATHWAYS THROUGH TIME ----
      div(
        class = "home-section-transparent",
        
        h3("Temporal Variability in Dominant Exposure Pathway During Migration", class = "tile-title"),
        p(
          "These panels show the percentage of cumulative realized risk attributed to exposure versus foraging across predation scenarios for alewives and striped bass. Displaying both species together highlights how pathway dominance differs between migratory prey and opportunistic predators.",
          class = "helper-text"
        ),
        
        fluidRow(
          column(
            8,
            
            div(
              class = "tile-pop",
              style = "padding: 14px; margin-bottom: 18px;",
              h3("Alewives", class = "tile-title", style = "text-align:center; margin-top: 0;"),
              plotlyOutput(ns("plot_pathway_alewife"), height = "300px")
            ),
            
            div(
              class = "tile-pop",
              style = "padding: 14px;",
              h3("Striped Bass", class = "tile-title", style = "text-align:center; margin-top: 0;"),
              plotlyOutput(ns("plot_pathway_stripedbass"), height = "300px")
            )
          ),
          
          column(
            4,
            div(
              class = "tile-white tile-pop",
              style = "padding: 18px; min-height: 636px; margin-top: 40px;",
              h3("Exposure Pathways", class = "tile-title",
                 style = "color:#0f1f2d!important;"),
              p(
                "Exposure pathways differ not only between species, but also over the course of migration. For alewives, gill exposure dominates at the onset of migration, reaching nearly 100% of realized risk early in the season when feeding is suppressed during landward movement. As migration progresses and fish transition to outmigration, foraging contributions increase, but gill exposure remains the dominant cumulative pathway across all scenarios.",
                class = "helper-text",
                style = "color:#0f1f2d!important;"
              ),
              p(
                "Striped bass follow a fundamentally different trajectory. While gill exposure initially accounts for most risk at the beginning of migration, foraging rapidly overtakes as predation intensifies in late May and early June. In all scenarios, ingestion becomes the dominant pathway, eventually contributing nearly all realized risk as feeding drives accumulation.",
                class = "helper-text",
                style = "color:#0f1f2d!important;"
              ),
              p(
                "Across scenarios, these patterns show that exposure is structured by behavior rather than environmental conditions alone. For alewives, risk emerges from sustained contact with contaminated water during migration, while for striped bass, risk is driven by trophic interactions that produce rapid and non-linear increases in exposure. This means that reducing contamination risk depends on whether exposure is controlled by movement through contaminated areas or by concentrated feeding interactions within them.",
                class = "helper-text",
                style = "color:#0f1f2d!important;"
              )
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ---- PROPORTIONAL CONTRIBUTION TABLE + PIE CHARTS --------------------------------
      div(
        class = "home-section-transparent",
        
        h3("Behavioral Control of Exposure Pathways", class = "tile-title"),
        p(
          "These pie charts show the proportional contribution of exposure and foraging to cumulative realized risk for alewives and striped bass under each predation scenario.",
          class = "helper-text"
        ),
        
        fluidRow(
          column(
            6,
            selectInput(
              ns("pie_scenario"), "Predation Scenario",
              choices = c(
                "No Predation" = "None",
                "Low Predation" = "Low",
                "Base Predation" = "Baseline",
                "High Predation" = "High"
              ),
              selected = "Baseline"
            )
          )
        ),
        
        fluidRow(
          column(
            8,
            fluidRow(
              column(
                6,
                div(
                  class = "tile-pop",
                  style = "padding: 14px;",
                  h3("Alewife", class = "tile-title", style = "text-align:center; margin-top: 0;"),
                  plotlyOutput(ns("pie_alewife"), height = "320px")
                )
              ),
              column(
                6,
                div(
                  class = "tile-pop",
                  style = "padding: 14px;",
                  h3("Striped Bass", class = "tile-title", style = "text-align:center; margin-top: 0;"),
                  plotlyOutput(ns("pie_stripedbass"), height = "320px")
                )
              )
            )
          ),
          
          column(
            4,
            div(
              class = "tile-white tile-pop",
              style = "padding: 18px; min-height: 360px;",
              h3("What Drives Exposure Risk?", class = "tile-title", style = "color:#0f1f2d!important;"),
              p(
                "Each chart shows how total realized exposure risk is distributed across different behavioral pathways (gill exposure and foraging). For alewives, most exposure comes from direct contact with contaminated water and suspended particles during migration. For striped bass, a larger portion of exposure comes from feeding on contaminated prey.",
                class = "helper-text", style = "color:#0f1f2d!important;"
              ),
              p(
                "Comparing scenarios shows how changes in predator–prey interactions shift the balance between exposure pathways. Even when total realized exposure risk remains similar, the way contamination enters the food web can change, which has important implications for how risk is managed.",
                class = "helper-text", style = "color:#0f1f2d!important;"
              )
            )
          )
        ),
        
        fluidRow(
          column(
            12,
            tags$div(
              class = "hero-figure-caption",
              "Percentages reflect the proportion of cumulative realized risk attributed to each pathway within the selected predation scenario."
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # -----------------------------
      # Limitations
      # -----------------------------
      column(
        width = 12,
        card(
          class = "tile-pop",
          card_body(
            div(
              h3(
                "Model Limitations and Considerations",
                class = "tile-title",
                style = "font-weight: 700;"
              )
            ),
            p(
              "This model represents a simplified version of a complex estuarine system. Methylmercury (MeHg) concentrations are treated as spatially fixed and do not include dynamic biogeochemical processes such as transformation or redistribution over time. In addition, fish in the model begin with no prior contaminant burden, meaning exposure reflects accumulation during migration rather than total lifetime exposure. In reality, fish may enter the estuary with existing contamination from earlier life stages, which could increase overall risk, especially for predators that accumulate contaminants through feeding.",
              class = "helper-text",
              style = "text-align: left;"
            ),
            p(
              "Model uncertainty also arises from how biological and environmental processes are represented. Parameters such as swimming behavior, metabolism, salinity tolerance, and contaminant uptake are based on available studies from similar systems and species. While these values fall within realistic ranges, small differences can influence movement patterns, encounter rates, and exposure outcomes. Sensitivity analyses show that the model is generally robust, with most changes affecting the magnitude of exposure rather than altering the dominant pathways or overall patterns.",
              class = "helper-text",
              style = "text-align: left;"
            ),
            p(
              "The model also does not include learning, spatial memory, or socially transmitted behavior. In reality, fish such as striped bass often return to the same locations and may follow learned or shared movement patterns across years. These behaviors could influence where and when exposure occurs. Future model development could incorporate these processes to better capture how movement strategies evolve over time and how exposure pathways may shift across generations.",
              class = "helper-text",
              style = "text-align: left;"
            ),
            p(
              "Despite these limitations, the model captures the dominant processes that structure exposure within the estuary. By linking hydrodynamics, behavior, and contaminant pathways, it provides a useful framework for understanding how exposure emerges and for identifying where management actions may be most effective.",
              class = "helper-text",
              style = "text-align: left;"
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # -----------------------------
      # Management Implications
      # -----------------------------
      column(
        width = 10,
        offset = 1,
        card(
          class = "tile-white tile-pop",
          card_body(
            div(
              h3(
                "What Are the Management Implications of These Findings?",
                class = "tile-title",
                style = "color:#0f1f2d !important;"
              )
            ),
            p(
              "This analysis shows that contamination risk is shaped not only by where contamination is located, but also by how fish move and interact within the estuary. Areas where fish slow down, aggregate, or repeatedly pass through, such as migration corridors and feeding zones, can produce higher cumulative exposure even when contamination levels are similar elsewhere. In this system, exposure is not just a property of place, but reflects how fish interact with contaminated environments over time.",
              class = "helper-text",
              style = "text-align: center;"
            ),
            p(
              "The model also shows that exposure pathways differ across species. Alewives accumulate contamination primarily through direct contact with contaminated water and suspended particles during migration, whereas striped bass accumulate contamination mainly through feeding on contaminated prey. Although predator–prey interactions strongly influence exposure, directly managing predation is often not feasible. Instead, these results highlight the importance of considering food web dynamics alongside environmental contamination when evaluating risk.",
              class = "helper-text",
              style = "text-align: center;"
            ),
            p(
              "From a management perspective, these findings suggest that mitigation and remediation may be most effective when focused on where and when exposure actually occurs. In practice, not all contaminated areas can be remediated, and large-scale interventions may be constrained by cost or feasibility. Identifying high-interaction zones, where fish movement, residence time, and feeding activity are concentrated, can help prioritize actions that reduce toxicity risk more efficiently than broad, uniform approaches.",
              class = "helper-text",
              style = "text-align: center;"
            ),
            p(
              "The results also show that exposure does not scale linearly with contaminant concentration, residence time, or predator density. Small changes in behavior or interaction patterns can produce large changes in realized risk, meaning that areas with similar contamination levels can still produce very different outcomes depending on how fish use those spaces.",
              class = "helper-text",
              style = "text-align: center;"
            ),
            p(
              "Managing contaminant risk requires focusing on how and where exposure actually occurs within the system. Areas that may appear similar in contamination can still produce different outcomes depending on how fish move through them and interact within them. This means that effective management is less about treating all contaminated areas equally and more about identifying the locations and times where exposure is most likely to build.",
              class = "helper-text",
              style = "text-align: center;"
            )
          )
        )
      ),
      
      div(class = "section-space"),
      
      # ---- KEY REFERENCES ----------------------------------------------------
      fluidRow(
        h3("Key References", class = "tile-title", style = "text-align:center;"),
        p("The behavioral modeling framework and exposure dynamics presented in this section draw from anadromous fish ecology, bioenergetics, agent-based modeling methodology, and mercury biogeochemistry. Key references are listed below.", class = "helper-text"),
        tags$ul(class = "helper-text reference-list",
                tags$li("Grimm, V., et al. (2010). The ODD protocol: A review and first update. ", tags$em("Ecological Modelling"), ", 221(23), 2760–2768. ", tags$a(href = "https://doi.org/10.1016/j.ecolmodel.2010.08.019", "https://doi.org/10.1016/j.ecolmodel.2010.08.019", target = "_blank")),
                tags$li("Railsback, S. F., & Harvey, B. C. (2013). Trait-mediated trophic interactions: is foraging theory keeping up? ", tags$em("Trends in Ecology & Evolution"), ", 28(3), 175–184."),
                tags$li("Dudley, R. K., et al. (2025). FHAST: A fish habitat and survival tool. ", tags$em("Ecological Modelling")),
                tags$li("Collette, B. B., & Klein-MacPhee, G. (2002). ", tags$em("Bigelow and Schroeder's Fishes of the Gulf of Maine"), " (3rd ed.). Smithsonian Books."),
                tags$li("Oros, D. R., et al. (2025). Bioaccumulation of methylmercury in estuarine food webs. ", tags$em("Environmental Science & Technology")),
                tags$li("Bodaly, R. A., & Kopec, A. D. (2013). ", tags$em("Penobscot River Mercury Study: Phase II"), ". U.S. District Court."),
                tags$li("Burchard, H., et al. (1998). Formation of estuarine turbidity maxima due to density effects in the salt wedge. ", tags$em("Estuaries"), ", 21, 507–517. ", tags$a(href = "https://doi.org/10.2307/1352906", "https://doi.org/10.2307/1352906", target = "_blank")),
                tags$li("Quintana, V., et al. (in prep). GoFish: A co-developed behavioral library for anadromous fish modeling in estuarine systems. University of Maine / U.S. ERDC.")
        )
      )
      )
    ) # /fluidPage
  ) # /tabPanel
  
  
}


# =============================================================================
# SERVER
# =============================================================================

tab_behavioral_risk_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    # ------------------------------------------------------------------
    # Shared constants
    # ------------------------------------------------------------------
    ABM_DIR    <- "data/ABM"
    SCEN_LEVELS <- c("none", "low", "base", "high")
    SCEN_LABELS <- c("None", "Low", "Base", "High")   # display labels
    SCEN_COLS   <- c(none = "#B35806", low = "#998EC3", base = "#5AB4AC", high = "#7FBF7B")
    SCEN_LTYS   <- c(none = "solid",   low = "dash",    base = "solid",   high = "dot")
    N_ALEWIFE   <- 4000
    N_BASS      <- 4
    
    # ------------------------------------------------------------------
    # Glossary toggle
    # ------------------------------------------------------------------
    observeEvent(input$toggle_glossary, {
      shinyjs::toggleClass(id = "glossary_tab", class = "open")
    })
    
    # ==================================================================
    # LOAD DATA ONCE ON MODULE STARTUP
    # All paths relative to app root (www/data/ABM/...)
    # ==================================================================
    
    # ---- 1. Temporal risk profiles (prey + pred) ----
    # Columns: scenario, metric, datetime, mean, ci_low, ci_high, n_runs, species
    # metrics: mehg_total, mehg_exposure_total, mehg_foraging_total,
    #          mehg_exposure_duration, mehg_uptake_risk, mehg_foraging_undigested,
    #          landward_migration, seaward_migration
    prey_profiles <- reactive({
      path <- file.path(ABM_DIR, "prey_temporal_risk_profiles.rds")
      df   <- readRDS(path)
      data.table::setDT(df)
      df[, datetime := as.POSIXct(datetime, tz = "UTC")]
      df[, date     := as.Date(datetime)]
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df
    })
    
    pred_profiles <- reactive({
      path <- file.path(ABM_DIR, "pred_temporal_risk_profiles.rds")
      df   <- readRDS(path)
      data.table::setDT(df)
      df[, datetime := as.POSIXct(datetime, tz = "UTC")]
      df[, date     := as.Date(datetime)]
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df
    })
    
    # Daily aggregation (mean of hourly CI means — matches post-processing script)
    prey_daily <- reactive({
      prey_profiles()[
        ,
        .(mean    = mean(mean,    na.rm = TRUE),
          ci_low  = mean(ci_low,  na.rm = TRUE),
          ci_high = mean(ci_high, na.rm = TRUE),
          n_runs  = max(n_runs,   na.rm = TRUE)),
        by = .(scenario, metric, date)
      ]
    })
    
    pred_daily <- reactive({
      pred_profiles()[
        ,
        .(mean    = mean(mean,    na.rm = TRUE),
          ci_low  = mean(ci_low,  na.rm = TRUE),
          ci_high = mean(ci_high, na.rm = TRUE),
          n_runs  = max(n_runs,   na.rm = TRUE)),
        by = .(scenario, metric, date)
      ]
    })
    
    # ---- 2. Dam / entry-exit CSVs ----
    # Columns: run, scenario, doy, date, Dam_enter, Milford, Milford_prop, DamEntry_prop
    # One file per scenario (already pre-aggregated across runs in post-processing)
    dam_all <- reactive({
      files <- list(
        none = file.path(ABM_DIR, "dam_daily_run_2_20_26_none.csv"),
        low  = file.path(ABM_DIR, "dam_daily_run_2_20_26_low.csv"),
        base = file.path(ABM_DIR, "dam_daily_run_2_20_26_base.csv"),
        high = file.path(ABM_DIR, "dam_daily_run_2_20_26_high.csv")
      )
      df <- data.table::rbindlist(
        lapply(names(files), function(s) {
          d <- data.table::fread(files[[s]])
          d[, scenario := s]
          d
        }),
        fill = TRUE
      )
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df[, date     := as.Date(doy - 1, origin = "2023-01-01")]
      df
    })
    
    # Daily mean + CI across runs (proportion scale)
    dam_sum <- reactive({
      dam_all()[
        ,
        .(mean    = mean(DamEntry_prop, na.rm = TRUE),
          ci_low  = mean(DamEntry_prop, na.rm = TRUE) - 1.96 * sd(DamEntry_prop, na.rm = TRUE) / sqrt(pmax(.N, 1)),
          ci_high = mean(DamEntry_prop, na.rm = TRUE) + 1.96 * sd(DamEntry_prop, na.rm = TRUE) / sqrt(pmax(.N, 1)),
          Milford = mean(Milford,       na.rm = TRUE)),
        by = .(scenario, date)
      ]
    })
    
    # ---- 3. Milford Dam validation CSV ----
    # Columns: DoY, Milford (raw count)
    milford_val <- reactive({
      df <- data.table::fread(
        file.path(ABM_DIR, "Penobscot_Mercury_Exposure Milford Fish Lift Validation.csv")
      )
      data.table::setnames(df, tolower(names(df)))
      df[, date := as.Date(doy - 1, origin = "2023-01-01")]
      df[, milford_prop := milford / 5490383]
      df[is.finite(milford)]
    })
    
    # ---- 4. Percent contribution daily CSV ----
    # Columns: species, scenario, date, pathway (Exposure/Foraging), pct_contribution
    pct_daily <- reactive({
      df <- data.table::fread(
        file.path(ABM_DIR, "percent_contribution_to_net_realized_risk_daily.csv")
      )
      df[, date     := as.Date(date)]
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df[is.finite(pct_contribution)]
    })
    
    # ---- 5. Percent contribution summary (end-of-migration) ----
    # Columns: species, scenario, pathway, mean_pct, median_pct, ...
    pct_summary <- reactive({
      df <- data.table::fread(
        file.path(ABM_DIR, "percent_contribution_summary_across_migration.csv")
      )
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df
    })
    
    # ---- 6. Dominant behavior last timestep ----
    # Columns: species, scenario, dominant_pathway, dominant_mean_pct
    dominant_beh <- reactive({
      df <- data.table::fread(
        file.path(ABM_DIR, "dominant_behavior_percent_last_timestep.csv")
      )
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df
    })
    
    # ---- Temporal risk profiles for time-series panel -------------------
    profiles_daily_ts <- reactive({
      df <- readRDS(file.path(ABM_DIR, "temporal_risk_profiles.rds"))
      data.table::setDT(df)
      
      df[, datetime := as.POSIXct(datetime, tz = "UTC")]
      df[, date := as.Date(datetime)]
      
      df[, species  := factor(species,  levels = c("Alewives", "Striped bass"))]
      df[, scenario := factor(scenario, levels = c("none", "low", "base", "high"))]
      
      # daily summaries from precomputed hourly summaries
      daily <- df[
        ,
        .(
          mean    = mean(mean, na.rm = TRUE),
          ci_low  = mean(ci_low, na.rm = TRUE),
          ci_high = mean(ci_high, na.rm = TRUE),
          n_runs  = max(n_runs, na.rm = TRUE)
        ),
        by = .(species, scenario, metric, date)
      ]
      
      # recompute mehg_total from daily exposure + foraging
      expo <- daily[
        metric == "mehg_exposure_total",
        .(species, scenario, date,
          mean_expo = mean, ci_low_expo = ci_low, ci_high_expo = ci_high, n_runs_expo = n_runs)
      ]
      
      fora <- daily[
        metric == "mehg_foraging_total",
        .(species, scenario, date,
          mean_fora = mean, ci_low_fora = ci_low, ci_high_fora = ci_high, n_runs_fora = n_runs)
      ]
      
      sum_df <- merge(expo, fora, by = c("species", "scenario", "date"), all = TRUE)
      
      sum_df[is.na(mean_expo), `:=`(mean_expo = 0, ci_low_expo = 0, ci_high_expo = 0)]
      sum_df[is.na(mean_fora), `:=`(mean_fora = 0, ci_low_fora = 0, ci_high_fora = 0)]
      
      sum_df[, mean_total := mean_expo + mean_fora]
      sum_df[, `:=`(
        ci_low_total  = pmax(ci_low_expo + ci_low_fora, 0),
        ci_high_total = pmax(ci_high_expo + ci_high_fora, 0),
        n_runs = pmax(n_runs_expo, n_runs_fora, na.rm = TRUE)
      )]
      
      total_long <- sum_df[, .(
        species, scenario, metric = "mehg_total", date,
        mean = mean_total,
        ci_low = ci_low_total,
        ci_high = ci_high_total,
        n_runs
      )]
      
      daily <- daily[metric != "mehg_total"]
      daily <- data.table::rbindlist(list(daily, total_long), use.names = TRUE, fill = TRUE)
      data.table::setorder(daily, species, scenario, metric, date)
      
      daily
    })
    
    ts_plot_data <- reactive({
      df <- profiles_daily_ts()
      
      species_label <- if (input$ts_species == "alewife") "Alewives" else "Striped bass"
      
      metric_key <- switch(
        input$ts_metric,
        net_risk  = "mehg_total",
        duration  = "mehg_exposure_duration",
        gill      = "mehg_exposure_total",
        foraging  = "mehg_foraging_total"
      )
      
      out <- df[species == species_label & metric == metric_key]
      out[is.finite(mean) & !is.na(mean)]
    })
    
    # ---- 7. TIF rasters — loaded lazily per map selection ----
    # Pattern: {Scenario}_{Metric}_{Species}.tif
    # Metrics: MeHg_CumulativeRisk, MinutesSpent
    # Species: Alewife, StripedBass
    load_raster_df <- function(scenario_key, metric_key, species_key) {
      # metric_key: "MeHg_CumulativeRisk" | "MinutesSpent"
      # species_key: "Alewife" | "StripedBass"
      scen_cap <- paste0(toupper(substr(scenario_key, 1, 1)),
                         substr(scenario_key, 2, nchar(scenario_key)))
      fname <- file.path(ABM_DIR,
                         paste0(scen_cap, "_", metric_key, "_", species_key, ".tif"))
      if (!file.exists(fname)) return(NULL)
      
      r   <- terra::rast(fname)
      r_ll <- terra::project(r, "EPSG:4326")
      
      # Convert to data.frame of (lon, lat, value) for Leaflet circles
      df <- as.data.frame(r_ll, xy = TRUE)
      names(df) <- c("lon", "lat", "value")
      df <- df[is.finite(df$value) & df$value > 0, ]
      df
    }
    
    # ==================================================================
    # MILFORD DAM EVALUATION
    # One evaluation plot + one metric table only
    # ==================================================================
    
    milford_eval_data <- reactive({
      d <- dam_all()
      req(nrow(d) > 0)
      
      daily <- d[
        ,
        .(
          Milford        = mean(Milford, na.rm = TRUE),
          Dam_enter_mean = mean(Dam_enter, na.rm = TRUE),
          sd_val         = sd(Dam_enter, na.rm = TRUE),
          n_runs         = sum(!is.na(Dam_enter))
        ),
        by = .(scenario, doy, date)
      ]
      
      daily[, se := sd_val / sqrt(pmax(n_runs, 1))]
      daily[, ci_low := pmax(Dam_enter_mean - 1.96 * se, 0)]
      daily[, ci_high := Dam_enter_mean + 1.96 * se]
      
      daily
    })
    
    milford_scale <- reactive({
      d <- milford_eval_data()
      max_mil <- max(d$Milford, na.rm = TRUE)
      max_sim <- max(d$Dam_enter_mean, na.rm = TRUE)
      if (is.finite(max_sim) && max_sim > 0) max_mil / max_sim else 1
    })
    
    output$plot_milford_eval <- renderPlotly({
      d   <- milford_eval_data()
      sf  <- milford_scale()
      obs <- d[scenario == "base"]
      
      gc  <- "rgba(255,255,255,0.12)"
      axc <- "#D0D0D0"
      
      p <- plotly::plot_ly()
      
      p <- p |>
        plotly::add_bars(
          data = obs,
          x = ~date,
          y = ~Milford,
          name = "Observed (Milford Dam 2023)",
          marker = list(color = "rgba(180,180,180,0.45)"),
          hovertemplate = "Observed<br>%{x|%b %d}<br>Count: %{y:,.0f}<extra></extra>"
        )
      
      for (s in SCEN_LEVELS) {
        d_s <- d[scenario == s][order(date)]
        lbl <- SCEN_LABELS[match(s, SCEN_LEVELS)]
        col <- SCEN_COLS[[s]]
        lty <- SCEN_LTYS[[s]]
        
        if (nrow(d_s) == 0) next
        
        fill_rgba <- sub("rgb\\(", "rgba(", sub("\\)$", ",0.18)", plotly::toRGB(col)))
        
        p <- p |>
          plotly::add_ribbons(
            data = d_s,
            x = ~date,
            ymin = ~ci_low * sf,
            ymax = ~ci_high * sf,
            fillcolor = fill_rgba,
            line = list(width = 0),
            showlegend = FALSE,
            hoverinfo = "skip"
          ) |>
          plotly::add_lines(
            data = d_s,
            x = ~date,
            y = ~Dam_enter_mean * sf,
            name = lbl,
            line = list(color = col, width = 2, dash = lty),
            customdata = ~round(Dam_enter_mean),
            hovertemplate = paste0(
              "<b>", lbl, "</b><br>%{x|%b %d}<br>",
              "Simulated passage: %{customdata:,.0f}<extra></extra>"
            )
          )
      }
      
      p |>
        plotly::layout(
          barmode = "overlay",
          xaxis = list(
            title = "Date",
            tickformat = "%b %d",
            dtick = "M1",
            gridcolor = gc,
            tickfont = list(color = axc),
            linecolor = "rgba(255,255,255,0.3)"
          ),
          yaxis = list(
            title = "Milford Dam Observed Count",
            tickformat = ",d",
            gridcolor = gc,
            tickfont = list(color = axc),
            color = axc
          ),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.24,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 20, b = 80, l = 70, r = 50),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor = "rgba(0,0,0,0)",
          font = list(color = "#E6E6E6"),
          hovermode = "x unified",
          hoverlabel = list(
            font = list(color = "black")
          )
        ) |>
        plotly::config(displaylogo = FALSE)
    })
    
    output$milford_r2_table <- renderTable({
      d <- milford_eval_data()
      
      r2_rows <- lapply(SCEN_LEVELS, function(s) {
        d_s <- d[scenario == s & is.finite(Milford) & is.finite(Dam_enter_mean)]
        if (nrow(d_s) < 3) return(NULL)
        
        mil_n <- d_s$Milford / max(d_s$Milford, na.rm = TRUE)
        sim_n <- d_s$Dam_enter_mean / max(d_s$Dam_enter_mean, na.rm = TRUE)
        
        r2 <- tryCatch(
          summary(lm(sim_n ~ mil_n))$r.squared,
          error = function(e) NA_real_
        )
        
        cr <- tryCatch(
          cor(mil_n, sim_n, use = "complete.obs"),
          error = function(e) NA_real_
        )
        
        data.frame(
          Scenario = SCEN_LABELS[match(s, SCEN_LEVELS)],
          R2 = round(r2, 2),
          Correlation = round(cr, 2),
          check.names = FALSE
        )
      })
      
      out <- do.call(rbind, Filter(Negate(is.null), r2_rows))
      names(out)[names(out) == "R2"] <- "R²"
      out
    }, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", align = "c")
    
    observeEvent(input$eval_tabs, {
      if (input$eval_tabs == "Alewife") {
        session$sendCustomMessage("force_plotly_resize", list(id = ns("plot_milford_eval")))
      }
    }, ignoreInit = FALSE)
    
    # =============================================================================
    # Striped Bass Hunting Probability Evaluation — Interactive Plotly
    # Drop this server block inside tab_behavioral_risk_server()
    # Assumes pred_h data.table is already built (pred_hourly_attempt_success())
    # =============================================================================
    pred_h <- readRDS(file.path(ABM_DIR, "pred_h_hunting.rds"))
    data.table::setDT(pred_h)
    pred_h[, scenario := factor(scenario, levels = SCEN_LEVELS)]
    
    # ------------------------------------------------------------------
    # Reactive: fit logistic model once from pred_h
    # ------------------------------------------------------------------
    hunt_model <- reactive({
      d <- pred_h  # swap for pred_h if it's not a reactive in your module
      req(nrow(d) > 0)
      glm(
        hunting01 ~ prey_present + abs(patch_velocity) + patch_salinity + patch_temperature,
        data   = d,
        family = binomial()
      )
    })
    
    # Reactive: data ranges for grid bounds
    hunt_ranges <- reactive({
      d <- pred_h
      list(
        vel_min  = min(abs(d$patch_velocity),   na.rm = TRUE),
        vel_max  = max(abs(d$patch_velocity),   na.rm = TRUE),
        temp_min = min(d$patch_temperature,     na.rm = TRUE),
        temp_max = max(d$patch_temperature,     na.rm = TRUE),
        sal_min  = min(d$patch_salinity,        na.rm = TRUE),
        sal_max  = max(d$patch_salinity,        na.rm = TRUE)
      )
    })
    
    output$plot_hunt_eval <- renderPlotly({
      m      <- hunt_model()
      ranges <- hunt_ranges()
      prey   <- as.integer(input$hunt_prey)
      
      vel_seq  <- seq(ranges$vel_min,  ranges$vel_max,  length.out = 80)
      temp_seq <- seq(ranges$temp_min, ranges$temp_max, length.out = 80)
      sal_seq  <- seq(ranges$sal_min,  ranges$sal_max,  length.out = 80)
      
      # Grid 1: velocity × temperature (median salinity)
      g1 <- expand.grid(
        patch_velocity    = vel_seq,
        patch_temperature = temp_seq,
        patch_salinity    = median(pred_h$patch_salinity, na.rm = TRUE),
        prey_present      = prey
      )
      g1$pred_prob <- predict(m, newdata = g1, type = "response")
      mat1 <- matrix(g1$pred_prob, nrow = length(vel_seq), ncol = length(temp_seq))
      
      # Grid 2: velocity × salinity (median temperature)
      g2 <- expand.grid(
        patch_velocity    = vel_seq,
        patch_salinity    = sal_seq,
        patch_temperature = median(pred_h$patch_temperature, na.rm = TRUE),
        prey_present      = prey
      )
      g2$pred_prob <- predict(m, newdata = g2, type = "response")
      mat2 <- matrix(g2$pred_prob, nrow = length(vel_seq), ncol = length(sal_seq))
      
      contour_style <- list(
        coloring   = "heatmap",
        colorscale = list(
          list(0,    "rgb(0,0,0)"),
          list(0.25, "rgb(87,15,109)"),
          list(0.5,  "rgb(188,55,84)"),
          list(0.75, "rgb(249,142,9)"),
          list(1,    "rgb(252,253,191)")
        ),
        zmin = 0, zmax = 1,
        contours = list(
          start = 0, end = 1, size = 0.1,
          showlabels = TRUE,
          labelfont  = list(color = "white", size = 10)
        ),
        colorbar = list(
          title      = "Hunting<br>Probability",
          tickformat = ".0%",
          titlefont  = list(color = "#E6E6E6", size = 12),
          tickfont   = list(color = "#E6E6E6", size = 11),
          len        = 0.8
        )
      )
      
      p1 <- plotly::plot_ly(
        x    = vel_seq,
        y    = temp_seq,
        z    = t(mat1),
        type = "contour",
        colorscale  = contour_style$colorscale,
        zmin        = 0, zmax = 1,
        contours    = contour_style$contours,
        colorbar    = contour_style$colorbar,
        hovertemplate = "Velocity: %{x:.2f} m s⁻¹<br>Temp: %{y:.1f} °C<br>Hunt prob: %{z:.1%}<extra></extra>"
      )
      
      p2 <- plotly::plot_ly(
        x    = vel_seq,
        y    = sal_seq,
        z    = t(mat2),
        type = "contour",
        colorscale  = contour_style$colorscale,
        zmin        = 0, zmax = 1,
        contours    = contour_style$contours,
        showscale   = FALSE,
        hovertemplate = "Velocity: %{x:.2f} m s⁻¹<br>Salinity: %{y:.1f} psu<br>Hunt prob: %{z:.1%}<extra></extra>"
      )
      
      ax <- function(title) list(
        title     = title,
        tickfont  = list(color = "#D0D0D0"),
        color     = "#D0D0D0",
        gridcolor = "rgba(255,255,255,0.08)"
      )
      
      plotly::subplot(p1, p2, nrows = 1, shareY = FALSE, titleX = TRUE, titleY = TRUE, margin = 0.08) |>
        plotly::layout(
          annotations = list(
            list(x = 0.02, y = 1.08, text = "<b>a)</b> Velocity × Temperature",
                 xref = "paper", yref = "paper", showarrow = FALSE,
                 xanchor = "left",
                 font = list(color = "#E6E6E6", size = 16)),
            list(x = 0.55, y = 1.08, text = "<b>b)</b> Velocity × Salinity",
                 xref = "paper", yref = "paper", showarrow = FALSE,
                 xanchor = "left",
                 font = list(color = "#E6E6E6", size = 16))
          ),
          xaxis  = ax("Patch Velocity (m s⁻¹)"),
          yaxis  = ax("Patch Temperature (°C)"),
          xaxis2 = ax("Patch Velocity (m s⁻¹)"),
          yaxis2 = ax("Patch Salinity (psu)"),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font          = list(color = "#E6E6E6"),
          margin        = list(t = 50, b = 60, l = 70, r = 20),
          hoverlabel    = list(font = list(color = "black"))
        ) |>
        plotly::config(displaylogo = FALSE)
    })
    
    # ------------------------------------------------------------------
    # Estuary Entry/Exit
    # ------------------------------------------------------------------
    dam_globals <- local({
      runs      <- 1:3
      scenarios <- c("none", "low", "base", "high")
      
      file_index <- data.table::CJ(scenario = scenarios, run = runs)
      file_index[, file := file.path(ABM_DIR, paste0("results_daily_", scenario, "_", run, ".csv"))]
      file_index <- file_index[file.exists(file)]
      
      N_by_metric <- c(
        alewives_entering_estuary    = 4000,
        alewives_exiting_estuary     = 4000,
        stripedbass_entering_estuary = 4,
        stripedbass_exiting_estuary  = 4
      )
      
      dam_cols <- c("ticks", "alewives_entering_estuary", "alewives_exiting_estuary",
                    "stripedbass_entering_estuary", "stripedbass_exiting_estuary")
      
      raw <- data.table::rbindlist(lapply(seq_len(nrow(file_index)), function(i) {
        df <- data.table::fread(file_index$file[i], select = dam_cols, showProgress = FALSE)
        df[, `:=`(run = file_index$run[i], scenario = file_index$scenario[i])]
        df
      }), fill = TRUE)
      
      raw[, date := as.Date(as.POSIXct("2023-04-01 00:00:00", tz = "UTC") + ticks * 5 * 60)]
      
      # melt to long
      long <- data.table::melt(raw,
                               id.vars      = c("ticks", "run", "scenario", "date"),
                               measure.vars = names(N_by_metric),
                               variable.name = "metric",
                               value.name    = "value"
      )
      long[is.na(value), value := 0]
      
      # daily count per run
      daily_run <- long[, .(count_day = sum(value, na.rm = TRUE)),
                        by = .(scenario, run, date, metric)]
      
      denom_dt <- data.table::data.table(
        metric = names(N_by_metric),
        denom  = unname(N_by_metric)
      )
      daily_run <- denom_dt[daily_run, on = "metric"]
      daily_run[, prop_day := count_day / denom]
      
      # CI across runs
      daily_run[,
                .(
                  n       = sum(!is.na(prop_day)),
                  mean    = mean(prop_day,  na.rm = TRUE),
                  sd      = sd(prop_day,    na.rm = TRUE),
                  se      = sd(prop_day,    na.rm = TRUE) / sqrt(pmax(sum(!is.na(prop_day)), 1)),
                  ci_low  = mean(prop_day,  na.rm = TRUE) - 1.96 * sd(prop_day, na.rm = TRUE) / sqrt(pmax(sum(!is.na(prop_day)), 1)),
                  ci_high = mean(prop_day,  na.rm = TRUE) + 1.96 * sd(prop_day, na.rm = TRUE) / sqrt(pmax(sum(!is.na(prop_day)), 1))
                ),
                by = .(scenario, date, metric)
      ]
    })
    
    # ---- 10. Temporal risk profiles (for migration lines) ----
    profiles_daily_dt <- local({
      df <- readRDS(file.path(ABM_DIR, "temporal_risk_profiles.rds"))
      data.table::setDT(df)
      df[, datetime := as.POSIXct(datetime, tz = "UTC")]
      df[, date     := as.Date(datetime)]
      df[, scenario := factor(scenario, levels = SCEN_LEVELS)]
      df[, species  := factor(species,  levels = c("Alewives", "Striped bass"))]
      
      # aggregate to daily
      df[,
         .(
           mean    = mean(mean,    na.rm = TRUE),
           ci_low  = mean(ci_low,  na.rm = TRUE),
           ci_high = mean(ci_high, na.rm = TRUE),
           n_runs  = max(n_runs,   na.rm = TRUE)
         ),
         by = .(species, scenario, metric, date)
      ]
    })
    
    output$plot_entry_exit <- renderPlotly({
      sp <- input$entry_species
      
      if (sp == "alewife") {
        enter_metric <- "alewives_entering_estuary"
        exit_metric  <- "alewives_exiting_estuary"
        sp_label     <- "Alewives"
      } else {
        enter_metric <- "stripedbass_entering_estuary"
        exit_metric  <- "stripedbass_exiting_estuary"
        sp_label     <- "Striped bass"
      }
      
      # --- dam entry/exit bars ---
      dam_sp <- dam_globals[metric %in% c(enter_metric, exit_metric)]
      dam_sp[, type := data.table::fifelse(metric == enter_metric, "Enter", "Exit")]
      dam_sp[, mean := pmax(as.numeric(mean), 0, na.rm = TRUE)]
      
      # --- migration lines from profiles_daily_dt ---
      mig <- profiles_daily_dt[
        metric %in% c("landward_migration", "seaward_migration") &
          species == sp_label
      ]
      mig[, mean := pmax(as.numeric(mean), 0, na.rm = TRUE)]
      
      left_max <- 0.05
      sf       <- left_max / 1     # right axis 0–1 compressed to left scale
      gc       <- "rgba(255,255,255,0.12)"
      axc      <- "#D0D0D0"
      
      p <- plotly::plot_ly()
      
      # --- bars per scenario ---
      for (s in SCEN_LEVELS) {
        col <- SCEN_COLS[[s]]
        lbl <- SCEN_LABELS[match(s, SCEN_LEVELS)]
        
        d_enter <- dam_sp[scenario == s & type == "Enter"][order(date)]
        d_exit  <- dam_sp[scenario == s & type == "Exit"][order(date)]
        
        if (nrow(d_enter) > 0)
          p <- p |> plotly::add_bars(
            data          = d_enter,
            x             = ~date,
            y             = ~mean,
            name          = paste(lbl, "Enter"),
            legendgroup   = paste0(s, "_bar"),
            marker        = list(color = col, opacity = 0.6),
            hovertemplate = paste0("<b>", lbl, " Enter</b><br>%{x|%b %d}<br>Prop: %{y:.3f}<extra></extra>")
          )
        
        if (nrow(d_exit) > 0)
          p <- p |> plotly::add_bars(
            data          = d_exit,
            x             = ~date,
            y             = ~mean,
            name          = paste(lbl, "Exit"),
            legendgroup   = paste0(s, "_bar"),
            showlegend    = FALSE,
            marker        = list(color = col, opacity = 0.25),
            hovertemplate = paste0("<b>", lbl, " Exit</b><br>%{x|%b %d}<br>Prop: %{y:.3f}<extra></extra>")
          )
      }
      
      # --- migration lines per scenario ---
      for (s in SCEN_LEVELS) {
        col <- SCEN_COLS[[s]]
        lbl <- SCEN_LABELS[match(s, SCEN_LEVELS)]
        
        lw <- mig[scenario == s & metric == "landward_migration"][order(date)]
        sw <- mig[scenario == s & metric == "seaward_migration"][order(date)]
        
        if (nrow(lw) > 0)
          p <- p |> plotly::add_lines(
            data          = lw,
            x             = ~date,
            y             = ~mean * sf,
            name          = paste(lbl, "Landward"),
            legendgroup   = paste0(s, "_line"),
            line          = list(color = col, width = 2, dash = "solid"),
            customdata    = ~round(mean, 3),
            hovertemplate = paste0("<b>", lbl, " Landward</b><br>%{x|%b %d}<br>Prop: %{customdata}<extra></extra>")
          )
        
        if (nrow(sw) > 0)
          p <- p |> plotly::add_lines(
            data          = sw,
            x             = ~date,
            y             = ~mean * sf,
            name          = paste(lbl, "Seaward"),
            legendgroup   = paste0(s, "_line"),
            showlegend    = FALSE,
            line          = list(color = col, width = 2, dash = "dash"),
            customdata    = ~round(mean, 3),
            hovertemplate = paste0("<b>", lbl, " Seaward</b><br>%{x|%b %d}<br>Prop: %{customdata}<extra></extra>")
          )
      }
      
      n_ticks    <- 6
      left_ticks <- seq(0, left_max, length.out = n_ticks)
      right_labs <- round(left_ticks / sf, 2)
      
      p |> plotly::layout(
        barmode = "overlay",
        xaxis = list(
          title      = "Date",
          tickformat = "%b %d",
          dtick      = "M1",
          range      = c("2023-03-28", "2023-10-22"),
          gridcolor  = gc,
          tickfont   = list(color = axc),
          color      = axc
        ),
        yaxis = list(
          title     = "Proportion Entering / Exiting Estuary",
          range     = c(0, left_max * 1.05),
          gridcolor = gc,
          tickfont  = list(color = axc),
          color     = axc
        ),
        yaxis2 = list(
          title      = "Proportion in Active Migration",
          overlaying = "y",
          side       = "right",
          range      = c(0, left_max * 1.05),
          tickvals   = left_ticks,
          ticktext   = right_labs,
          showgrid   = FALSE,
          tickfont   = list(color = axc),
          color      = axc
        ),
        legend = list(
          orientation = "h", x = 0.5, xanchor = "center", y = -0.22,
          font    = list(color = "#E6E6E6"),
          bgcolor = "rgba(0,0,0,0)"
        ),
        margin        = list(t = 20, b = 80, l = 70, r = 80),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor  = "rgba(0,0,0,0)",
        font          = list(color = "#E6E6E6"),
        hovermode     = "x unified",
        hoverlabel    = list(font = list(color = "black"))
      ) |>
        plotly::config(displaylogo = FALSE)
    })
    
    # ------------------------------------------------------------------
    # Risk and Residence Maps
    # ------------------------------------------------------------------
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
    
    # Fit bounds padding
    pad_west  <- 0.20
    pad_east  <- 0.03
    pad_south <- 0.20
    pad_north <- 0.20
    
    lng_vals <- c(sites$lng, dams$lng, pollution$lng)
    lat_vals <- c(sites$lat, dams$lat, pollution$lat)
    
    # -----------------------------
    # Load rasters once
    # -----------------------------
    r_mercury       <- terra::rast("data/k_mercury.tif")
    r_methylmercury <- terra::rast("data/k_methylmercury.tif")
    
    r_mercury[r_mercury <= 0]             <- NA
    r_methylmercury[r_methylmercury <= 0] <- NA
    
    r_mercury_ll       <- terra::project(r_mercury, "EPSG:4326")
    r_methylmercury_ll <- terra::project(r_methylmercury, "EPSG:4326")
    
    # Palettes for background contamination layers
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
    # Load ABM rasters once
    # -----------------------------
    abm_rasters <- local({
      scenarios <- c("None", "Low", "Base", "High")
      metrics   <- c(
        cum_risk  = "MeHg_CumulativeRisk",
        residence = "MinutesSpent",
        gill      = "MeHg_GillExposureRisk",
        foraging  = "MeHg_ForagingRisk"
      )
      species <- c(
        alewife     = "Alewife",
        stripedbass = "StripedBass"
      )
      
      out <- list()
      
      for (scen in scenarios) {
        for (met_key in names(metrics)) {
          for (sp_key in names(species)) {
            
            fname <- file.path(
              ABM_DIR,
              paste0(scen, "_", metrics[[met_key]], "_", species[[sp_key]], ".tif")
            )
            
            if (!file.exists(fname)) next
            
            r <- terra::rast(fname)
            r_ll <- terra::project(r, "EPSG:4326")
            
            key <- paste(scen, met_key, sp_key, sep = "__")
            out[[key]] <- r_ll
          }
        }
      }
      
      out
    })
    
    # -----------------------------
    # Initialize abm_map
    # -----------------------------
    output$abm_map <- renderLeaflet({
      leaflet(options = leafletOptions(preferCanvas = TRUE)) |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldTerrain, group = "Terrain") |>
        
        # Background contamination rasters
        addRasterImage(
          r_mercury_ll,
          colors = pal_hg,
          opacity = 0.65,
          project = FALSE,
          group = "Mercury (THg)"
        ) |>
        addRasterImage(
          r_methylmercury_ll,
          colors = pal_mehg,
          opacity = 0.65,
          project = FALSE,
          group = "Methylmercury (MeHg)"
        ) |>
        
        # Reference markers
        addAwesomeMarkers(
          data = dams,
          lng = ~lng, lat = ~lat,
          icon = dam_icon,
          label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>Status: ", status),
          group = "Dams"
        ) |>
        addAwesomeMarkers(
          data = pollution,
          lng = ~lng, lat = ~lat,
          icon = pollution_icon,
          label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>", role),
          group = "Pollution Sources"
        ) |>
        addAwesomeMarkers(
          data = sites,
          lng = ~lng, lat = ~lat,
          icon = site_icons,
          label = ~name,
          popup = ~paste0("<b>", name, "</b><br/>", role),
          group = "Field Sites"
        ) |>
        
        addLayersControl(
          baseGroups = c("Satellite", "Light", "Terrain"),
          overlayGroups = c(
            "Mercury (THg)",
            "Methylmercury (MeHg)",
            "Dams",
            "Pollution Sources",
            "Field Sites",
            "Risk Layer"
          ),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        
        fitBounds(
          lng1 = min(c(terra::ext(r_mercury_ll)$xmin)),
          lat1 = min(c(terra::ext(r_mercury_ll)$ymin)),
          lng2 = max(c(terra::ext(r_mercury_ll)$xmax)),
          lat2 = max(c(terra::ext(r_mercury_ll)$ymax))
        ) |>
        
        hideGroup(c("Mercury (THg)", "Methylmercury (MeHg)")) |>
        
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
    # Sync background raster legends
    # -----------------------------
    observe({
      grps <- input$abm_map_groups
      if (is.null(grps)) grps <- character(0)
      
      proxy <- leafletProxy(ns("abm_map")) |>
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
    
    # -----------------------------
    # Update ABM risk layer
    # -----------------------------
    observe({
      req(input$map_species, input$map_metric, input$map_scenario)
      
      scen_label <- switch(
        input$map_scenario,
        "None"     = "None",
        "Low"      = "Low",
        "Baseline" = "Base",
        "High"     = "High"
      )
      
      key <- paste(scen_label, input$map_metric, input$map_species, sep = "__")
      
      proxy <- leafletProxy(ns("abm_map")) |>
        clearGroup("Risk Layer") |>
        removeControl("risk_legend")
      
      r <- abm_rasters[[key]]
      
      if (is.null(r)) {
        return()
      }
      
      vals <- terra::values(r, mat = FALSE)
      vals <- vals[is.finite(vals) & vals > 0]
      
      if (length(vals) == 0) {
        return()
      }
      
      vmax <- stats::quantile(vals, 0.98, na.rm = TRUE)
      r_cap <- r
      r_cap[r_cap <= 0] <- NA
      r_cap[r_cap > vmax] <- vmax
      
      pal <- leaflet::colorNumeric(
        palette  = "YlOrRd",
        domain   = c(0, vmax),
        na.color = "transparent"
      )
      
      metric_label <- switch(
        input$map_metric,
        cum_risk  = "Cumulative MeHg Risk",
        residence = "Residence Time (min)",
        gill      = "Gill Exposure Risk",
        foraging  = "Foraging Risk"
      )
      
      species_label <- switch(
        input$map_species,
        alewife = "Alewife",
        stripedbass = "Striped Bass"
      )
      
      scenario_label <- switch(
        input$map_scenario,
        "None" = "No Predation",
        "Low" = "Low Predation",
        "Baseline" = "Base Predation",
        "High" = "High Predation"
      )
      
      proxy |>
        addRasterImage(
          r_cap,
          colors = pal,
          opacity = 0.8,
          project = FALSE,
          group = "Risk Layer"
        ) |>
        addLegend(
          position  = "bottomright",
          pal       = pal,
          values    = c(0, vmax),
          title     = paste0(metric_label, "<br>", species_label, " — ", scenario_label),
          labFormat = leaflet::labelFormat(
            transform = function(x) signif(x, 3)
          ),
          opacity = 0.9,
          layerId = "risk_legend"
        )
    })
    
    map_lat_range <- reactive({
      b <- input$abm_map_bounds
      
      if (!is.null(b) && !is.null(b$south) && !is.null(b$north)) {
        c(b$south, b$north)
      } else {
        ext <- terra::ext(r_mercury_ll)
        c(ext$ymin, ext$ymax)
      }
    })
    
    # -----------------------------
    # Vertical latitude profile data
    # -----------------------------
    lat_profile_data <- reactive({
      req(input$map_species, input$map_metric, input$map_scenario)
      
      scen_label <- switch(
        input$map_scenario,
        "None"     = "None",
        "Low"      = "Low",
        "Baseline" = "Base",
        "High"     = "High"
      )
      
      key <- paste(scen_label, input$map_metric, input$map_species, sep = "__")
      r <- abm_rasters[[key]]
      req(!is.null(r))
      
      df <- as.data.frame(r, xy = TRUE, na.rm = TRUE)
      names(df) <- c("lon", "lat", "value")
      df <- df[is.finite(df$value) & df$value > 0, ]
      req(nrow(df) > 0)
      
      # cap to match map display
      vmax <- stats::quantile(df$value, 0.98, na.rm = TRUE)
      df$value_cap <- pmin(df$value, vmax)
      
      # keep only map-visible latitude range
      lat_rng <- map_lat_range()
      df <- df[df$lat >= lat_rng[1] & df$lat <= lat_rng[2], ]
      req(nrow(df) > 0)
      
      # latitude bins for smooth vertical profile
      lat_breaks <- seq(lat_rng[1], lat_rng[2], length.out = 140)
      
      df$lat_bin <- cut(df$lat, breaks = lat_breaks, include.lowest = TRUE)
      
      prof <- df |>
        dplyr::group_by(lat_bin) |>
        dplyr::summarise(
          lat = mean(lat, na.rm = TRUE),
          risk = mean(value_cap, na.rm = TRUE),
          risk_low = quantile(value_cap, 0.25, na.rm = TRUE),
          risk_high = quantile(value_cap, 0.75, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(lat)
      
      prof
    })
    
    output$plot_lat_profile_vertical <- renderPlotly({
      prof <- lat_profile_data()
      req(nrow(prof) > 0)
      
      lat_rng <- map_lat_range()
      
      metric_label <- switch(
        input$map_metric,
        cum_risk  = "Cumulative MeHg Risk",
        residence = "Residence Time (min)",
        gill      = "Gill Exposure Risk",
        foraging  = "Foraging Risk"
      )
      
      p <- plotly::plot_ly()
      
      # ribbon
      p <- p |>
        plotly::add_trace(
          x = c(prof$risk_low, rev(prof$risk_high)),
          y = c(prof$lat, rev(prof$lat)),
          type = "scatter",
          mode = "lines",
          fill = "toself",
          line = list(color = "transparent"),
          fillcolor = "rgba(120,120,120,0.20)",
          hoverinfo = "skip",
          showlegend = FALSE
        )
      
      # main vertical profile
      p <- p |>
        plotly::add_trace(
          data = prof,
          x = ~risk,
          y = ~lat,
          type = "scatter",
          mode = "lines",
          line = list(width = 3, color = "#1f4e79"),
          hovertemplate = paste0(
            "Latitude: %{y:.4f}<br>",
            metric_label, ": %{x:.3g}<extra></extra>"
          ),
          showlegend = FALSE
        )
      
      # site reference lines
      site_shapes <- lapply(seq_len(nrow(sites)), function(i) {
        list(
          type = "line",
          x0 = 0, x1 = 1,
          xref = "paper",
          y0 = sites$lat[i], y1 = sites$lat[i],
          yref = "y",
          line = list(color = "gray", dash = "dot", width = 1)
        )
      })
      
      p |>
        plotly::layout(
          margin = list(t = 10, r = 10, b = 50, l = 65),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor = "rgba(0,0,0,0)",
          xaxis = list(
            title = metric_label,
            zeroline = FALSE
          ),
          yaxis = list(
            title = "Latitude",
            range = lat_rng,
            tickformat = ".3f",
            fixedrange = TRUE
          ),
          shapes = site_shapes,
          hovermode = "closest"
        ) |>
        plotly::config(displaylogo = FALSE)
    })
    
    # -----------------------------
    # Temporal Risk Plots
    # -----------------------------
    
    output$plot_ts_risk <- renderPlotly({
      df <- ts_plot_data()
      req(nrow(df) > 0)
      
      metric_label <- switch(
        input$ts_metric,
        net_risk  = "Net Realized Risk",
        duration  = "Exposure Duration (minutes)",
        gill      = "Gill Uptake Risk",
        foraging  = "Foraging Risk"
      )
      
      species_label <- if (input$ts_species == "alewife") "Alewife" else "Striped Bass"
      
      gc  <- "rgba(255,255,255,0.12)"
      axc <- "#D0D0D0"
      
      p <- plotly::plot_ly()
      
      for (s in SCEN_LEVELS) {
        d_s <- df[scenario == s][order(date)]
        if (nrow(d_s) == 0) next
        
        lbl <- SCEN_LABELS[match(s, SCEN_LEVELS)]
        col <- SCEN_COLS[[s]]
        lty <- SCEN_LTYS[[s]]
        
        p <- p |>
          plotly::add_lines(
            data = d_s,
            x = ~date,
            y = ~mean,
            name = lbl,
            line = list(color = col, width = 2.5, dash = lty),
            hovertemplate = paste0(
              "<b>", lbl, "</b><br>",
              "%{x|%b %d, %Y}<br>",
              metric_label, ": %{y:.3g}<extra></extra>"
            )
          )
      }
      
      p |>
        plotly::layout(
          title = list(
            text = paste0(species_label, ": ", metric_label),
            x = 0.5,
            xanchor = "center"
          ),
          xaxis = list(
            title = "Date",
            tickformat = "%b %d",
            dtick = "M1",
            range = c("2023-03-30", "2023-10-20"),
            gridcolor = gc,
            tickfont = list(color = axc),
            color = axc
          ),
          yaxis = list(
            title = metric_label,
            tickformat = ".2e",
            gridcolor = gc,
            tickfont = list(color = axc),
            color = axc
          ),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.22,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 55, b = 80, l = 75, r = 20),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font = list(color = "#E6E6E6"),
          hovermode = "x unified",
          hoverlabel = list(font = list(color = "black"))
        ) |>
        plotly::config(displaylogo = FALSE)
    })
    
    output$ts_interpret_text <- renderUI({
      txt <- switch(
        paste(input$ts_species, input$ts_metric, sep = "_"),
        
        # ---------------- ALEWIFE ----------------
        "alewife_net_risk" = tagList(
          p(
            "This plot shows how net realized risk accumulates for alewives after estuary entry in early May. Risk increases progressively through the migration period, with all scenarios following a similar trajectory through early and mid-summer before diverging later in the season.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Maximum realized risk ranges from approximately 1.99 × 10^5 to 3.20 × 10^5 across predation scenarios. This steady accumulation reflects the migratory behavior of alewives, where exposure builds through repeated contact with contaminated suspended material rather than discrete events.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "This pattern shows that exposure is structured primarily by movement through the estuary rather than predator-driven interactions. Hydrodynamics define where exposure is possible, but behavior determines how consistently fish encounter those conditions over time.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "As a result, alewife risk reflects a corridor-based process, where cumulative burden emerges from sustained transit through contaminated regions rather than short-term spikes in interaction intensity.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "alewife_duration" = tagList(
          p(
            "This plot shows cumulative exposure duration for alewives across the migration season. Exposure duration increases steadily following estuary entry, reflecting sustained residence within the estuarine corridor rather than short-term exposure events.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Duration ranges from approximately 4.29 × 10^3 to 5.21 × 10^3 minutes and varies only modestly across predation scenarios. This indicates that time spent in contaminated regions remains relatively stable under different predator conditions.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Because alewives suppress feeding during migration, exposure duration becomes a primary driver of cumulative risk. Longer residence within hydrodynamically structured regions increases total contact with contaminated suspended material.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "This reinforces that for migratory prey, exposure is controlled more by how long fish remain within the system than by how intensively they interact with other organisms.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "alewife_gill" = tagList(
          p(
            "This plot shows cumulative gill uptake risk for alewives through time. Gill exposure increases gradually after estuary entry and remains highly consistent across predation scenarios, reflecting continuous environmental contact.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Values range from approximately 1.86 × 10^5 to 1.96 × 10^5, showing minimal variation across scenarios. This indicates that gill uptake is largely independent of predator density and driven by sustained interaction with contaminated water and suspended particulate matter.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Across all scenarios, gill exposure accounts for the majority of total realized risk, reflecting the obligate migratory behavior of alewives and limited feeding during upstream movement.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "This demonstrates that exposure is dominated by environmental pathways, where cumulative burden emerges from continuous contact rather than discrete trophic events.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "alewife_foraging" = tagList(
          p(
            "This plot shows cumulative foraging risk for alewives across the migration period. Unlike gill uptake, this pathway shows stronger variation across scenarios and sharper increases during periods of active feeding.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Foraging risk ranges from approximately 1.36 × 10^4 to 1.24 × 10^5 and varies non-linearly with predation conditions. The lowest ingestion occurs under baseline conditions, while both reduced and elevated predation increase feeding-related exposure.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "These differences indicate that predator density restructures feeding intensity rather than scaling ingestion in a simple proportional way. Behavioral responses alter when and where feeding occurs within the estuary.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Even so, foraging remains a secondary pathway for alewives, reinforcing that exposure is primarily driven by migration through contaminated environments rather than trophic interactions.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        # ---------------- STRIPED BASS ----------------
        "stripedbass_net_risk" = tagList(
          p(
            "This plot shows how net realized risk accumulates for striped bass after estuary entry. Unlike alewives, risk does not increase gradually but instead rises abruptly, with scenarios diverging rapidly over time.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Maximum realized risk ranges from approximately 1.62 × 10^8 to 4.61 × 10^9, representing order-of-magnitude differences across predation scenarios. This indicates strong sensitivity to predation density and feeding intensity.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "This pattern reflects the dominance of trophic transfer, where exposure is driven by discrete predation events rather than continuous environmental contact. Risk accumulation is therefore event-based rather than time-based.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Small changes in encounter structure produce large differences in accumulated burden, showing that exposure is governed by behavioral interactions rather than simply time spent within the estuary.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "stripedbass_duration" = tagList(
          p(
            "This plot shows cumulative exposure duration for striped bass across the migration season. Exposure duration remains low relative to alewives, reflecting shorter and more variable residence within contaminated areas.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Duration ranges from 0 to approximately 2.7 × 10^2 minutes, with minimal accumulation under the no predation scenario. This indicates limited sustained occupation of contaminated habitat.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Despite short residence times, striped bass still accumulate substantial contaminant burden, indicating that exposure is not controlled by time alone.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "This highlights that short periods of interaction can produce high risk when exposure is driven by concentrated trophic events rather than continuous environmental contact.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "stripedbass_gill" = tagList(
          p(
            "This plot shows cumulative gill uptake risk for striped bass through time. Gill exposure increases gradually but remains within a relatively narrow range compared to total realized risk.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Values range from approximately 8.25 × 10^4 to 1.10 × 10^5, indicating that direct environmental uptake contributes only a small portion of total burden.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Compared to alewives, this pathway plays a much smaller role in overall exposure. Striped bass do not accumulate risk primarily through continuous contact with contaminated water.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Instead, this reflects a shift toward interaction-driven exposure, where feeding behavior rather than habitat contact determines the majority of accumulated risk.",
            style = "color:#0f1f2d!important;"
          )
        ),
        
        "stripedbass_foraging" = tagList(
          p(
            "This plot shows cumulative foraging risk for striped bass, which is the dominant exposure pathway. Risk increases sharply following predation events rather than accumulating gradually over time.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Foraging-driven exposure ranges from approximately 1.62 × 10^8 to 4.61 × 10^9, showing strong sensitivity to predation intensity and encounter structure.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "Ingestion rapidly overtakes environmental uptake, accounting for the majority of total realized risk. Exposure is therefore structured by predator–prey interactions rather than background environmental conditions.",
            style = "color:#0f1f2d!important;"
          ),
          p(
            "These results demonstrate that clustered feeding events can generate rapid and disproportionate increases in contaminant burden, even when overall residence time is limited.",
            style = "color:#0f1f2d!important;"
          )
        )
      )
      
      txt
    })
    
    # ------------------------------------------------------------------
    # Proportional Contribution of Exposure Pathways Through Time
    # ------------------------------------------------------------------
    pathway_alewife_data <- reactive({
      df <- pct_daily()
      df[species == "Alewives"]
    })
    
    pathway_bass_data <- reactive({
      df <- pct_daily()
      df[species == "Striped bass"]
    })
    
    make_species_pathway_plot <- function(df, species_label, show_legend = TRUE) {
      req(nrow(df) > 0)
      
      gc  <- "rgba(255,255,255,0.12)"
      axc <- "#D0D0D0"
      
      p <- plotly::plot_ly()
      
      for (s in SCEN_LEVELS) {
        d_exp <- df[scenario == s & pathway == "Exposure"][order(date)]
        d_for <- df[scenario == s & pathway == "Foraging"][order(date)]
        
        lbl <- SCEN_LABELS[match(s, SCEN_LEVELS)]
        col <- SCEN_COLS[[s]]
        
        if (nrow(d_exp) > 0) {
          p <- p |>
            plotly::add_lines(
              data = d_exp,
              x = ~date,
              y = ~pct_contribution,
              name = lbl,
              legendgroup = s,
              showlegend = show_legend,
              line = list(
                color = col,
                width = 2.5,
                dash = "solid"
              ),
              hovertemplate = paste0(
                "<b>", species_label, "</b><br>",
                "<b>", lbl, "</b><br>",
                "%{x|%b %d, %Y}<br>",
                "Exposure: %{y:.1f}%<extra></extra>"
              )
            )
        }
        
        if (nrow(d_for) > 0) {
          p <- p |>
            plotly::add_lines(
              data = d_for,
              x = ~date,
              y = ~pct_contribution,
              name = lbl,
              legendgroup = s,
              showlegend = FALSE,
              line = list(
                color = col,
                width = 2.5,
                dash = "dash"
              ),
              hovertemplate = paste0(
                "<b>", species_label, "</b><br>",
                "<b>", lbl, "</b><br>",
                "%{x|%b %d, %Y}<br>",
                "Foraging: %{y:.1f}%<extra></extra>"
              )
            )
        }
      }
      
      p |>
        plotly::layout(
          xaxis = list(
            title = "Date",
            tickformat = "%b %d",
            dtick = "M1",
            range = c("2023-03-30", "2023-10-20"),
            gridcolor = gc,
            tickfont = list(color = axc),
            color = axc
          ),
          yaxis = list(
            title = "% Contribution",
            range = c(0, 100),
            dtick = 20,
            ticksuffix = "%",
            gridcolor = gc,
            tickfont = list(color = axc),
            color = axc
          ),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.24,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 10, b = 90, l = 70, r = 20),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font = list(color = "#E6E6E6"),
          hovermode = "x unified",
          hoverlabel = list(
            bgcolor = "white",
            font = list(color = "black")
          )
        ) |>
        plotly::config(displaylogo = FALSE)
    }
    
    output$plot_pathway_alewife <- renderPlotly({
      make_species_pathway_plot(
        pathway_alewife_data(),
        "Alewives",
        show_legend = TRUE
      )
    })
    
    output$plot_pathway_stripedbass <- renderPlotly({
      make_species_pathway_plot(
        pathway_bass_data(),
        "Striped Bass",
        show_legend = TRUE
      )
    })
    
    # ---------------------------
    # Percent Contribution Table & Pie Charts
    # ---------------------------
    
    pie_input <- reactive({
      data.frame(
        scenario = c("None", "None",
                     "Low",  "Low",
                     "Base", "Base",
                     "High", "High"),
        pathway = c("Gill Exposure", "Foraging",
                    "Gill Exposure", "Foraging",
                    "Gill Exposure", "Foraging",
                    "Gill Exposure", "Foraging"),
        value = c(76, 85,
                  83, 85,
                  91, 87,
                  66, 85),
        stringsAsFactors = FALSE
      )
    })
    
    pie_scenario_key <- reactive({
      req(input$pie_scenario)
      if (input$pie_scenario == "Baseline") return("Base")
      input$pie_scenario
    })
    
    pie_species_data <- reactive({
      df <- pie_input()
      scen <- pie_scenario_key()
      
      df <- df[df$scenario == scen, , drop = FALSE]
      
      validate(
        need(nrow(df) > 0, paste("No pie data found for scenario:", scen))
      )
      
      df
    })
    
    make_pathway_pie <- function(df, title_text = "Dominant Behavior") {
      validate(
        need(nrow(df) > 0, "No data available for pie chart")
      )
      
      plotly::plot_ly(
        data = df,
        labels = ~pathway,
        values = ~value,
        type = "pie",
        sort = FALSE,
        textinfo = "label+percent",
        textposition = "outside",
        textfont = list(color = "#E6E6E6", size = 13),
        hovertemplate = paste0(
          "<b>", title_text, "</b><br>",
          "%{label}<br>",
          "Input value: %{value:.1f}<br>",
          "Relative share: %{percent}<extra></extra>"
        ),
        marker = list(
          colors = c("#59a14f", "#F4A259"),
          line = list(color = "rgba(255,255,255,0.15)", width = 1)
        ),
        showlegend = TRUE
      ) |>
        plotly::layout(
          title = list(
            text = title_text,
            x = 0.5,
            xanchor = "center",
            font = list(color = "#E6E6E6")
          ),
          font = list(color = "#E6E6E6"),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.22,
            font = list(color = "#E6E6E6"),
            bgcolor = "rgba(0,0,0,0)"
          ),
          margin = list(t = 40, b = 80, l = 30, r = 30),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          hoverlabel = list(
            bgcolor = "white",
            font = list(color = "black")
          )
        ) |>
        plotly::config(displaylogo = FALSE)
    }
    
    output$pie_alewife <- renderPlotly({
      df <- pie_species_data()
      make_pathway_pie(df, "Alewife")
    })
    
    output$pie_stripedbass <- renderPlotly({
      df <- pie_species_data()
      make_pathway_pie(df, "Striped Bass")
    })
    
    # -----------------------------
    # Limitations
    # -----------------------------
    
    # -----------------------------
    # Management Implications
    # -----------------------------
    
  }) # /moduleServer
} # /tab_behavioral_risk_server