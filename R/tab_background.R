tab_background_ui <- function(id = "background") {
  ns <- NS(id)
  
  tabPanel(
    title = "Background",
    value = "background",
    fluidPage(
      
      # ============================
      # INTRO (header band)
      # ============================
      div(
        class = "home-intro",
        
        fluidRow(
          column(
            12,
            div(
              class = "hero-header",
              h1("Mercury in the Penobscot River Estuary", class = "hero-title hero-title-overlay")
            )
          )
        ),
        
        ########## Glossary
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
            tags$dl(
              
              # Alewife
              tags$dt("Alewife"),
              tags$dd("A species of river herring that migrates from the ocean into rivers and lakes to spawn. In the Penobscot system, alewives use the estuary as a migration corridor and staging area."),
              
              # Anadromous Fish
              tags$dt("Anadromous Fish"),
              tags$dd("Fish species that migrate between marine and freshwater environments as part of their life cycle."),
              
              # Anadromy
              tags$dt("Anadromy"),
              tags$dd("A life history strategy where fish migrate between the ocean and freshwater to complete their life cycle, which can increase exposure opportunities in estuaries."),
              
              # Atlantic Salmon
              tags$dt("Atlantic Salmon"),
              tags$dd("An anadromous fish species that migrates between the ocean and freshwater rivers to spawn. Atlantic salmon use estuaries as migration corridors and transitional habitats during their life cycle."),
              
              # Atlantic Sturgeon
              tags$dt("Atlantic Sturgeon"),
              tags$dd("A large anadromous fish species that migrates between marine and freshwater environments. Atlantic sturgeon frequently interact with bottom sediments while feeding, which can influence exposure to sediment bound contaminants."),
              
              # Bacterial Methylation
              tags$dt("Bacterial Methylation"),
              tags$dd("A microbial process where bacteria convert inorganic mercury into methylmercury, most often under low oxygen conditions and in organic rich environments."),
              
              # Behavioral Pathways
              tags$dt("Behavioral Pathways"),
              tags$dd("Routes through which organism behavior, such as migration, feeding, or resting, shapes exposure to contaminants."),
              
              # Bioaccumulation
              tags$dt("Bioaccumulation"),
              tags$dd("The buildup of contaminants within an individual organism over time as uptake exceeds elimination."),
              
              # Bioavailability
              tags$dt("Bioavailability"),
              tags$dd("The extent to which a contaminant is available for uptake by organisms, influenced by chemical form, sediment type, and environmental conditions."),
              
              # Biomagnification
              tags$dt("Biomagnification"),
              tags$dd("The increase in contaminant concentration at higher levels of the food web as predators consume contaminated prey."),
              
              # Estuarine System
              tags$dt("Estuarine System"),
              tags$dd("A transition zone where freshwater from rivers mixes with saltwater from the ocean, shaped by tides, river discharge, and sediment transport."),
              
              # Exposure-Based Management
              tags$dt("Exposure-Based Management"),
              tags$dd("An approach to remediation and restoration that prioritizes reducing biologically meaningful exposure rather than only lowering contaminant concentrations."),
              
              # Exposure Opportunity
              tags$dt("Exposure Opportunity"),
              tags$dd("The likelihood that an organism encounters biologically available contamination based on where, when, and how it interacts with the environment."),
              
              # Fish Consumption
              tags$dt("Fish Consumption"),
              tags$dd("Eating fish as food. In mercury contaminated systems, consumption is a primary pathway for methylmercury exposure in people."),
              
              # Fish Consumption Advisory
              tags$dt("Fish Consumption Advisory"),
              tags$dd("Public health guidance that limits or restricts consumption of fish due to contamination risks."),
              
              # Habitat Availability
              tags$dt("Habitat Availability"),
              tags$dd("The presence of environmental conditions that support specific life stages of organisms, structured by depth, flow, salinity, and temperature."),
              
              # Inorganic Mercury
              tags$dt("Inorganic Mercury"),
              tags$dd("The dominant form of mercury stored in sediments that serves as the precursor for methylmercury production."),
              
              # Inorganic Sediments
              tags$dt("Inorganic Sediments"),
              tags$dd("Mineral dominated sediments with relatively low organic matter. These areas can store mercury, but typically support less methylmercury production than organic rich sediments."),
              
              # Legacy Contamination
              tags$dt("Legacy Contamination"),
              tags$dd("Pollution introduced historically that remains in the environment long after direct discharges have stopped, often stored in sediments."),
              
              # Life Stage
              tags$dt("Life Stage"),
              tags$dd("Distinct phases of an organism’s development, such as adult, egg, larval, or juvenile stages, each with different habitat and exposure pathways."),
              
              # Macrotidal
              tags$dt("Macrotidal"),
              tags$dd("A tidal system with a large tidal range (commonly greater than four meters), which increases current strength, mixing, and sediment transport."),
              
              # Meaningful Exposure
              tags$dt("Meaningful Exposure"),
              tags$dd("Exposure that occurs at biologically relevant times, locations, and durations sufficient to contribute to mercury uptake."),
              
              # Methylmercury (MeHg)
              tags$dt("Methylmercury (MeHg)"),
              tags$dd("An organic form of mercury produced by microbial processes that readily accumulates in organisms and biomagnifies through food webs."),
              
              # Microbial Methylation
              tags$dt("Microbial Methylation"),
              tags$dd("The biological process by which microorganisms convert inorganic mercury into methylmercury under favorable environmental conditions."),
              
              # Migration Corridor
              tags$dt("Migration Corridor"),
              tags$dd("A spatial pathway used by migratory species to move between habitats, often concentrating exposure opportunities in estuaries."),
              
              # Organic Sediments
              tags$dt("Organic Sediments"),
              tags$dd("Sediments with high organic matter content. These areas often support microbial activity that can influence mercury binding and methylmercury production."),
              
              # Remediation
              tags$dt("Remediation"),
              tags$dd("Actions taken to reduce contamination or limit exposure, such as sediment removal, capping, or isolation."),
              
              # Risk
              tags$dt("Risk"),
              tags$dd("The potential for harmful exposure arising from the overlap of biologically available contamination, habitat use, and behavior."),
              
              # Risk Assessment
              tags$dt("Risk Assessment"),
              tags$dd("A framework used to evaluate potential harm by linking contamination, exposure pathways, and biological response."),
              
              # River Discharge
              tags$dt("River Discharge"),
              tags$dd("The volume of water flowing from the river into the estuary, which influences sediment transport, contaminant movement, and habitat conditions."),
              
              # River Herring
              tags$dt("River Herring"),
              tags$dd("A group of migratory fish species that includes alewife and blueback herring. They move between marine and freshwater habitats and are culturally and ecologically important in Maine."),
              
              # Sediment Cap
              tags$dt("Sediment Cap"),
              tags$dd("A layer of clean material placed over contaminated sediment to reduce resuspension and biological exposure."),
              
              # Sediment-Associated Contaminants
              tags$dt("Sediment-Associated Contaminants"),
              tags$dd("Pollutants that bind to sediment particles rather than remaining dissolved in water, causing their movement to follow sediment transport pathways."),
              
              # Semidiurnal Macrotidal Estuary
              tags$dt("Semidiurnal Macrotidal Estuary"),
              tags$dd("An estuary with two high and two low tides each day and a large tidal range, producing strong tidal currents and frequent flow reversals."),
              
              # Shortnose Sturgeon
              tags$dt("Shortnose Sturgeon"),
              tags$dd("A long lived anadromous sturgeon species that inhabits rivers and estuaries. Shortnose sturgeon often reside in estuarine habitats for extended periods, increasing potential exposure to sediment associated contaminants."),
              
              # Striped Bass
              tags$dt("Striped Bass"),
              tags$dd("A migratory fish species that uses estuaries for feeding, growth, and seasonal movement. Striped bass can accumulate mercury through predation on contaminated prey within estuarine food webs."),
              
              # Subsistence
              tags$dt("Subsistence"),
              tags$dd("Using locally harvested resources, such as fish, to support food needs, cultural practices, and household wellbeing rather than solely for recreation or commercial purposes."),
              
              # Suspended Particulate Matter (SPM)
              tags$dt("Suspended Particulate Matter (SPM)"),
              tags$dd("Fine sediment and organic particles suspended in the water column that can transport contaminants such as mercury."),
              
              # Toxicity
              tags$dt("Toxicity"),
              tags$dd("Harmful effects on organisms that can occur when contaminants accumulate to biologically disruptive levels, potentially affecting behavior, growth, reproduction, and survival."),
              
              # Total Mercury (THg)
              tags$dt("Total Mercury (THg)"),
              tags$dd("The total amount of mercury present in sediment or water, including all chemical forms.")
            )
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
        
        ################################
        # ============================
        # SECTION 1: Community Over view
        # ============================
        # Penobscot Pollution
        # Why and how it became polluted (timeline, milling and HoltraCHem)
        # how much is it polluted
        # When can we expect it to go?
            
            # ---- Two-column layout: text (left) + image (right) ----
            fluidRow(
              column(
                5,
                div(
                  style =" margin-top: 50px;",
                card(
                  class = "tile-white tile-pop",
                  card_body(
                    div(
                h3("Overview", class = "tile-title", style = "text-align: center;"),
                div(
                  class = "how-to-text", style = "margin-top: 25px;",
                  p(
                    "The Penobscot River Estuary is a tidal river system that supports fisheries, wildlife, recreation, and communities throughout central and coastal Maine. It spans freshwater river reaches, transitional tidal zones, and estuarine environments where river flow and tides interact. These interacting forces shape how water moves, where sediment is stored, and how habitats form and change over time.",
                    style = "text-align: center;"
                  ),
                  p(
                    "As a semidiurnal macrotidal estuary, the Penobscot experiences tidal ranges greater than four meters twice a day, strong tidal currents, extensive intertidal zones, and seasonally variable river discharge. These conditions create a highly energetic system with constant movement and variability. The same physical processes that influence how contaminants move, accumulate, and persist also support productive habitat within the estuary.",
                    style = "text-align: center;"
                  ),
                  p(
                    "This ecological relevance is reflected in the biological importance of the system, which supports one of the largest documented river herring runs in North America, along with other migratory fish species such as Atlantic salmon, shortnose sturgeon, striped bass, and Atlantic sturgeon. Because these species rely on the estuary as a migration corridor, conditions within this system are strongly tied to their population health and long-term success.",
                    style = "text-align: center;"
                  )
                )
              )))
              )),
              
              column(
                7,
                div(
                  class = "side-image-wrap",
                  tags$figure(
                    class = "hero-figure",
                    div(
                      class = "hero-image-wrap",
                      
                      # 👇 Wrap image in link
                      tags$a(
                        href = "https://www.harvardmagazine.com/2018/06/elsie-sunderland-harvard",
                        target = "_blank",
                        
                        tags$img(
                          src = "mercury101.png",
                          class = "side-image",
                          alt = "Mercury cycle diagram (Harvard Magazine, Elsie Sunderland)",
                          style = "width: 100%; max-width: 600px; display: block; margin: 0 auto;"
                        )
                      )
                    ),
                    tags$figcaption(
                      class = "hero-figure-caption",
                      HTML(
                        'How mercury moves through the environment and up the food chain. 
           Source: <a href="https://www.harvardmagazine.com/2018/06/elsie-sunderland-harvard" target="_blank">Harvard Magazine</a>.'
                      )
                    )
                  )
                )
              )
            ),
        
        div(class = "section-space"),
        
        
        fluidRow(
          column(
            7,
            div(
              class = "hydro-map-wrap",
              
              leafletOutput(ns("hydro_map"), width = "100%", height = "750px"),
              
              div(
                class = "hydro-overlay-left",
                style = "margin-top: 450px;
                         background: linear-gradient(
                          rgba(15, 31, 45, 0.85),
                          rgba(15, 31, 45, 0.85)
                        );
                        padding: 28px 26px;
                        border-radius: 18px;
                      ",
                div(
                  class = "overlay-section",
                  h3(
                    "Penobscot River Estuary, ME",
                    class = "tile-title",
                    style = "color: #ffffff;"
                  ),
                  p(
                    "This interactive map provides geographic context for this application. Use the layer controls to view historical and existing dams, and the primary legacy mercury point source within the estuary.",
                    class = "helper-text",
                    style = "color: #ffffff; opacity: 0.95;"
                  )
                )
              )
            )
          ),
          column(
            5,
            div(
              style = "max-height: 750px; overflow-y: auto; padding-right: 12px;",
              h3("Legacy Mercury Contamination", class = "tile-title", style = "text-align: center;"),
              
              p(
                "During the mid-twentieth century, mercury entered the Penobscot River primarily through discharges associated with the HoltraChem chemical manufacturing facility in Orrington, Maine. The facility used mercury-cell technology to produce chlorine and caustic soda, and mercury was released directly to the river before environmental regulations limited such practices. Between the late 1960s and early 1970s, an estimated six to twelve tonnes of mercury were discharged into the system.",
                class = "helper-text"
              ),
              
              p(
                "Once released, mercury became incorporated into riverbed sediments, with an estimated 320,000 tonnes of contaminated sediment retained within the estuary. Over time, these sediments have been transported, deposited, and redistributed throughout the system by tidal currents and river discharge. Although direct discharges ceased decades ago, the contaminated sediments introduced during this period remain part of the estuarine system. This contamination reflects how materials introduced decades ago can continue to interact within an ecosystem.",
                class = "helper-text"
              ),
              
              p(
                "The Penobscot River is not uniformly contaminated. Mercury is unevenly distributed in sediments, reflecting where fine particles have accumulated, been buried, or repeatedly reworked by tides and river flow. Concentrations tend to be highest in lower-energy depositional areas and lowest in higher-energy zones where sediment is frequently scoured. Because mercury is closely associated with sediment, spatial patterns of contamination reflect both historical inputs and ongoing transport processes. Areas of higher concentration do not necessarily indicate new sources, but rather locations where contaminated material has been stored or repeatedly deposited.",
                class = "helper-text"
              ),
              
              p(
                "Mercury contamination in sediment does not disappear on short timescales. Its persistence depends on physical transport, burial, and removal processes. In tidal rivers like the Penobscot, contaminated sediment may be buried, resuspended, or transported downstream depending on hydrologic conditions. As a result, reductions in exposure opportunity occur gradually and unevenly. Some areas may retain contaminated sediments, while higher-energy areas of the estuary may frequently resuspend and transport contaminated material, making it difficult to define a single timeline for recovery across the entire system.",
                class = "helper-text"
              )
            )
          )
        )
      ),
      
      div(class = "section-space"),
      div(class = "section-space"),
      
      
      # ============================
      # SECTION 2: Why Mercury Matters 
      # ============================
      #
          fluidRow(
            column(
              6,
              card(
                class = "tile-white tile-pop",
                card_body(
                  div(
              h3("Mercury vs Methylmercury", class = "tile-title"),
              p(
                tags$b("Mercury (Hg)"),
                " occurs in multiple chemical forms, each with distinct ecological implications. Total mercury represents the sum of all mercury present in sediment or water, regardless of chemical form. Inorganic mercury constitutes the dominant fraction stored in sediments and serves as the precursor pool for methylmercury production.",
                class = "helper-text"
              ),
              p(
                tags$b("Methylmercury (MeHg)"),
                " is the organic form of mercury produced through microbial methylation processes, primarily under conditions that favor anaerobic microbial activity. Its formation depends on a suite of environmental factors, including organic matter availability, redox conditions, sediment residence time, and microbial community composition.",
                class = "helper-text"
              ),
              p(
                tags$b("Methylmercury is the primary concern in mercury-contaminated systems because it is readily taken up by organisms, efficiently bioaccumulates, and biomagnifies through food webs."),
                " This application distinguishes between mercury and methylmercury using inorganic and organic sediment types to explicitly represent how physical transport and sediment composition influence not only where mercury exists, but where it may become biologically relevant, meaning available for uptake and accumulation by organisms within the system.",
                class = "helper-text"
              )
            )))),
            
            column(
              6,
              div(
                class = "side-image-wrap",
                tags$figure(
                  class = "hero-figure",
                  div(
                    class = "hero-image-wrap",
                    tags$img(
                      src = "Methylation_Organic_Matter.gif",
                      class = "hero-image",
                      alt = "Microbial methylation of mercury in aquatic systems (PNNL)",
                      style = "width: 70%; height: 300px; cursor: pointer;",
                      onclick = "window.open('https://www.pnnl.gov/news-media/how-does-river-breathe', '_blank')"
                    )
                  ),
                  tags$figcaption(
                    class = "hero-figure-caption",
                    HTML(
                      "Microbial methylation transforms inorganic mercury into methylmercury, a bioavailable form that can be taken up by organisms and transferred through food webs. Source: <a href='https://www.pnnl.gov/news-media/how-does-river-breathe' target='_blank'>Pacific Northwest National Laboratory</a>."
                    )
                  )
                )
              )
            )
          ),
      
      #div(class = "section-space"),
      
      # ============================
      # SECTION 4: Mercury Toxicity in Anadromous Fish
      # ============================
          fluidRow(
            column(
              6,
              tags$figure(
                class = "hero-figure",
                div(
                  class = "hero-image-wrap",
                  tags$img(
                    src = "bioaccumulation.png",
                    class = "hero-image",
                    alt = "Bacterial methylation converts inorganic mercury to organic methylmercury. (image sourced from ...)",
                    style = "width: 800px; height: 500px;"
                  )
                ),
                tags$figcaption(
                  class = "hero-figure-caption",
                  "Illustration of bioaccumulation and biomagnification of mercury."
                )
              )
            ),
            column(
              6,
              h3("Why Contamination Matters", class = "tile-title", style = "margin-top: 25px; text-align: center;"),
              div(style = "margin-top: 25px; max-height: 450px; overflow-y: auto; padding-right: 12px;",
              p(
                "When methylmercury becomes available to food webs, it can be incorporated into organisms and transferred through ecological pathways. Once incorporated, methylmercury builds up within individual organisms through bioaccumulation, increasing in concentration as exposure continues. Because methylmercury binds strongly to tissue in fish and is not easily excreted, even low environmental concentrations can lead to elevated tissue burdens over time and the development of toxic body concentrations in fish. As contaminated organisms are consumed by predators, methylmercury concentrations increase further through biomagnification, resulting in the highest concentrations occurring in larger, longer-lived, and higher-trophic-level fish.",
                class = "helper-text"
              ),
              p(
                "For humans, these same processes are critical because consumption of contaminated fish is the primary pathway of methylmercury exposure. Methylmercury readily crosses the blood–brain barrier and the placenta, posing heightened risks to developing fetuses and young children. Health effects associated with methylmercury exposure include neurological impairment, developmental delays, and cognitive impacts, making mercury contamination in fish a direct concern for public health, subsistence practices, and food security.",
                class = "helper-text"
              ),
              p(
                "In estuarine environments, the processes that control when and where methylmercury becomes available are tightly linked to sediment transport, organic matter dynamics, and oxygen conditions. These same processes also shape habitat availability and interactions with contaminated sediments for fish and other organisms, creating overlapping physical and biological drivers of exposure that are difficult to observe directly, quantify, and predict.",
                class = "helper-text"
              ))
            )
          ),
      
      div(class = "section-space"),
      
      # ============================
      # SECTION 3: Mercury vs Methylmercury
      # ============================
          fluidRow(
            column(
              6,
              div(
                style = "max-height: 500px; overflow-y: auto; padding-right: 12px;",
              card(
                class = "tile-white tile-pop",
                card_body(
                  div(
              h3("Mercury Toxicity in Anadromous Fish", class = "tile-title"),
              p(
                "Anadromous fish, which migrate between marine and freshwater environments as part of their life cycle, are uniquely exposed to estuarine contamination because they rely on estuaries during critical phases of development and reproduction. These species undertake annual migrations that require repeated passage through estuarine environments, often across multiple life stages. In the Penobscot River system, anadromous fish are present within the estuary for extended portions of the year, generally from May through October, increasing the likelihood of encountering contaminated material under a wide range of hydrodynamic and ecological conditions.",
                class = "helper-text"
              ),
              p(
                "Different life stages interact with the estuary in fundamentally different ways based on their physiological constraints and resource requirements. Migrating adults typically move through deeper, higher-energy channels that support sustained swimming, orientation, and passage during upstream and downstream migration, while eggs, larvae, and juveniles are more closely associated with lower-energy habitats that meet developmental, feeding, and refuge needs and where fine sediments and organic matter are more likely to accumulate. These differences result in differential exposure opportunities that are structured by environmental conditions and behavior.",
                class = "helper-text"
              ),
              p(
                "Meaningful exposure occurs when fish interact with contaminated sediment directly or indirectly during migration. The majority of methylmercury exposure occurs through ingestion, primarily via feeding on contaminated small particulate material and through predation on other organisms that have already accumulated mercury. Additional, trace amounts of mercury may be taken up across the skin and gills as part of natural physiological processes, but these pathways represent a secondary contribution relative to dietary intake.",
                class = "helper-text"
              )
            ))))),
            column(
              6,
              tags$figure(
                class = "hero-figure",
                div(
                  style = "display:flex; justify-content:center;",
                  
                  tags$a(
                    href = "https://swimway.waddensea-worldheritage.org/life-cycle-approach",
                    target = "_blank",
                    
                    tags$img(
                      src = "LifeCycle.png",
                      class = "hero-image",
                      alt = "River herring life cycle diagram adapted from Swimway Wadden Sea",
                      style = "cursor: pointer;"
                    )
                  )
                ),
                tags$figcaption(
                  class = "hero-figure-caption",
                  HTML(
                    "Conceptual representation of the river herring life cycle across marine, estuarine, and freshwater environments, highlighting key stages of migration, spawning, and juvenile development. Adapted from <a href='https://swimway.waddensea-worldheritage.org/life-cycle-approach' target='_blank'>Swimway Wadden Sea</a>."
                  )
                )
              )
            )
          ),
      
      # ============================
      # SECTION 5: Remediation and Restoration
      # ============================
      
      div(class = "section-space"),
      

          fluidRow(
            column(
              width = 10,
              offset = 1,
              h3("Local Anadromous Fish", class = "tile-title", style = "text-align: center;"),
              p(
                "Anadromous fish hold strong ecological, cultural, and subsistence significance within the Penobscot River Estuary. Native species such as river herring, striped bass, Atlantic salmon, and sturgeon have historically supported food systems, livelihoods, and cultural practices throughout the watershed. These species also play key ecological roles, linking marine and freshwater systems through their migrations and contributing to nutrient transport and food webs within the system.",
                class = "helper-text"
              ),
              p(
                "Historically, populations of these species experienced substantial decline during the twentieth century from industrialization, habitat fragmentation, waterway alterations, water quality degradation, and contamination. Recent restoration efforts have improved habitat connectivity and access, but legacy contamination continues to constrain how these species can be safely used.",
                class = "helper-text"
              ),
              p("Communities throughout the watershed have long depended on these fisheries for subsistence, local economies, and cultural continuity. For the Penobscot Nation, whose ancestral homeland includes the Penobscot River Estuary, relationships with anadromous fish, particularly river herring, are deeply embedded in long-standing cultural traditions, stewardship responsibilities, and Traditional Knowledge. Mercury contamination therefore represents not only an ecological stressor, but a cultural and social one, as reduced access to safe fish creates direct barriers to the continuation of these practices.",
                class = "helper-text"),
              p("Fish consumption advisories have been in effect for the system since 1987 due to contamination, and current guidance recommends that children and women who are pregnant, breastfeeding, or may become pregnant avoid consumption of anadromous fish entirely, and that other adults limit consumption to no more than one meal per month.",
                class = "helper-text")
            )
      ),
      
      div(class = "section-space"),
      
      # ============================
      # SECTION 6: Conceptual Risk Framework
      # ============================
        fluidRow(
          column(
            8,
            div(
              tags$figure(
                class = "hero-figure",
                tags$img(
                  src   = "Figure_5B1_Synthesis_Figure.png",
                  alt   = "Conceptual figure showing sediment-bound contaminant exposure as an emergent process in a tidally influenced estuary",
                  style = "width:110%; border-radius:2px;"
                ),
                tags$figcaption(
                  "Contaminant exposure for sediment-bound contaminants such as mercury emerges from the interaction of material transport, physiologically suitable habitat, and behavior.",
                  class = "hero-figure-caption"
                )
              )
            )
          ),
          column(
            4,
            card(
              class = "tile-white tile-pop",
              card_body(
                div(
                  h3("Exposure as an Emergent Estuarine Process", class = "tile-title"),
                  p(
                    "This conceptual figure illustrates sediment-bound contaminant exposure as an emergent process rather than a static consequence of contaminant presence alone. In tidally influenced estuaries, exposure develops through the intersection of three interacting domains: hydrodynamically driven material transport, physiologically suitable habitat, and behaviorally mediated fish movement.",
                    class = "helper-text"
                  ),
                  p(
                    "Hydrodynamic transport governs where contaminated suspended particles are retained, resuspended, and redistributed throughout the estuary, shaping the spatial pattern of contaminant bioavailability. Physiologically suitable habitat constrains where fish can persist long enough for exposure to become biologically meaningful. Behavior then mediates realized interaction with contamination by determining when, where, and how fish encounter contaminated water, particulates, or prey.",
                    class = "helper-text"
                  ),
                  p(
                    "Within this framework, exposure is not controlled by any single factor in isolation. Instead, meaningful risk emerges where contaminated material is available, habitat conditions permit occupancy, and fish behavior brings individuals into contact with exposure pathways such as gill uptake, particulate feeding, or predation.",
                    class = "helper-text"
                  ),
                  p(
                    "This perspective helps move beyond static contamination maps by identifying exposure as a dynamic ecological outcome shaped by coupled physical and biological processes. It provides a systems-based foundation for understanding where sediment-bound contaminant risk is most likely to arise in estuarine environments.",
                    class = "helper-text"
                  )
                )
              )
            )
          )
      ),
      
     # div(class = "section-space"),
      
      fluidRow(
        column(
          7,
          h3("Risk Assessments", class = "tile-title", style = "margin-top: 80px; text-align: center;"),
          p("Risk assessments are the standard approach for evaluating mercury remediation and restoration projects, but they often emphasize changes in total contaminant concentrations rather than the processes that govern biological exposure to methylmercury. Engineering-based assessments can show whether remediation alters contaminant levels, but they do not indicate whether those changes reduce exposure for fish. Biological approaches such as tissue-based sampling confirm contamination in individual fish, yet they provide only a snapshot and cannot resolve where, when, or how exposure occurred. Similarly, habitat-based assessments are typically static representations that do not capture movement, interaction, or temporal variability. These limitations are especially pronounced for anadromous fish, whose exposure is seasonally constrained and structured by material transport processes, habitat availability, and behavior.",
            class = "helper-text"
          ),
          p("To evaluate mercury remediation projects for reducing toxicity, risk must be defined in terms of meaningful exposure opportunity. Throughout this application, risk is defined as exposure arising from the availability of sediment-associated methylmercury. The research presented here predicts when, where, and how fish are likely to encounter contaminated material within the Penobscot River and provides a basis for comparing relative exposure risk across hydrodynamic regimes, species, life stages, and behavioral strategies within estuarine systems.",
            class = "helper-text"
          )
        ),
        column(
          5,
          tags$figure(
            class = "hero-figure",
            div(
              class = "hero-image-wrap",
              style = "height: 400px; margin-top: 25px;",
              tags$img(
                src = "Risk.png",
                class = "hero-image",
                style = "height: 400px; width: auto;",
                alt = "Conceptual depiction of relative contamination exposure risk across behavioral and environmental conditions"
              )
            ),
            tags$figcaption(
              class = "hero-figure-caption",
              "Conceptual representation of risk."
            )
          )
        )
      ),
      div(class = "section-space"),
      
      # ============================
      # Closing callout (optional)
      # ============================
      column(
        width = 10,
        offset = 1,
        card(
          class = "tile-white tile-pop",
          card_body(
            div(
              h3(
                "Going Forward",
                class = "tile-title",
                style = "font-weight: 700; color:#0f1f2d !important;"
              )),
            p(
              "This application evaluates exposure risk for river herring within the Penobscot River by breaking mercury contamination dynamics into three interconnected components: material transport and retention, habitat availability, and migration behavior. The next section focuses on material transport and retention, illustrating how tides and river discharge regulate where contaminated sediments are stored, mobilized, and redistributed. The subsequent habitat availability section examines how shifts in suitable habitat across life stages structure where exposure opportunity exists. Finally, the behavior-mediated risk section explores how migration timing, movement, and behavioral decisions shape exposure during migration through the estuary.",
              class = "helper-text",
              style = "text-align: center; margin-bottom: 0;"
            )
          )
        )
      )
      )
    )
}

tab_background_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
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
        addProviderTiles(providers$CartoDB.Positron, group = "Light") |>
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") |>
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
          baseGroups = c( "Light", "Satellite", "Terrain"),
          overlayGroups = c("Mercury (THg)", "Methylmercury (MeHg)", "Dams", "Pollution Sources"),
          options = layersControlOptions(collapsed = FALSE)
        ) |>
        
        fitBounds(
          lng1 = min(c(terra::ext(r_mercury_ll)$xmin)),
          lat1 = min(c(terra::ext(r_mercury_ll)$ymin)),
          lng2 = max(c(terra::ext(r_mercury_ll)$xmax)),
          lat2 = max(c(terra::ext(r_mercury_ll)$ymax))
        ) |>
        
        # Default: show MeHg, hide THg
        hideGroup("Mercury (THg)") |>
        
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

                         

