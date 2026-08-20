# ==============================================================================
#  tab_about.R  |  About the Author — redesigned
#  - Large hero portrait with credential badges
#  - Masonry collage gallery with scroll-triggered staggered fade-in
#  - Progressive image loading via Intersection Observer
# ==============================================================================

tab_about_ui <- function(id = "about") {
  tabPanel(
    title = "About",
    value = "about",
    fluidPage(
      
      # ── ALL CSS + JS ───────────────────────────────────────────────────────
      tags$head(
        tags$style(HTML("
 
          /* ============================================================
             AUTHOR HERO CARD
          ============================================================ */
          .author-hero {
            display: flex;
            align-items: flex-start;
            gap: 36px;
            padding: 32px 0 24px 0;
          }
 
          /* Portrait column */
          .author-portrait-col {
            flex: 0 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
            min-width: 240px;
          }
 
          /* Portrait frame — rectangular card style */
          .author-portrait-frame {
            position: relative;
            width: 240px;
          }
 
          .author-portrait-img {
            width: 240px;
            height: 300px;
            object-fit: cover;
            object-position: center top;
            border-radius: 18px;
            border: 2px solid rgba(126,204,230,0.40);
            box-shadow:
              0 0 0 6px rgba(126,204,230,0.08),
              0 20px 50px rgba(0,0,0,0.55);
            display: block;
          }
 
          /* Teal accent strip at bottom of portrait */
          .author-portrait-frame::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 4px;
            border-radius: 0 0 18px 18px;
            background: linear-gradient(90deg,
              rgba(126,204,230,0), #7ecce6, rgba(126,204,230,0));
          }
 
          /* Credential badges below portrait */
          .author-badges {
            display: flex;
            flex-direction: column;
            gap: 7px;
            width: 100%;
          }
 
          .author-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 7px 12px;
            border-radius: 10px;
            background: rgba(126,204,230,0.10);
            border: 1px solid rgba(126,204,230,0.22);
            font-size: 0.82rem;
            color: rgba(200,230,245,0.90);
            line-height: 1.2;
          }
 
          .author-badge i {
            color: #7ecce6;
            font-size: 0.95rem;
            flex-shrink: 0;
          }
 
          /* Social link buttons */
          .author-socials {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
          }
 
          .author-social-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: 10px;
            background: rgba(79,179,217,0.18);
            border: 1px solid rgba(79,179,217,0.35);
            color: rgba(200,235,245,0.92) !important;
            text-decoration: none !important;
            font-size: 0.88rem;
            transition: background 0.2s, border-color 0.2s;
          }
 
          .author-social-btn:hover {
            background: rgba(79,179,217,0.30);
            border-color: rgba(79,179,217,0.55);
          }
 
          /* Bio column */
          .author-bio-col {
            flex: 1 1 0;
            min-width: 0;
          }
 
          .author-name-heading {
            font-size: 2.8rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.5px;
            margin: 0 0 4px 0;
            line-height: 1.05;
          }
 
          .author-title-line {
            font-size: 1.05rem;
            color: #7ecce6;
            font-weight: 600;
            margin: 0 0 18px 0;
            letter-spacing: 0.2px;
          }
 
          /* Get in contact CTA */
          .author-cta {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            border-radius: 12px;
            background: linear-gradient(135deg,
              rgba(79,179,217,0.35), rgba(126,204,230,0.25));
            border: 1px solid rgba(126,204,230,0.50);
            color: #ffffff !important;
            text-decoration: none !important;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 0.2px;
            transition: background 0.2s, box-shadow 0.2s;
            margin-bottom: 22px;
          }
 
          .author-cta:hover {
            background: linear-gradient(135deg,
              rgba(79,179,217,0.50), rgba(126,204,230,0.40));
            box-shadow: 0 6px 20px rgba(79,179,217,0.30);
          }
 
          /* Bio prose */
          .bio-prose {
            color: rgba(220,238,248,0.90);
            font-size: 1.02rem;
            line-height: 1.65;
            margin-bottom: 14px;
          }
 
          .bio-diss {
            padding: 12px 16px;
            border-left: 3px solid #7ecce6;
            background: rgba(126,204,230,0.07);
            border-radius: 0 10px 10px 0;
            color: rgba(200,230,245,0.88);
            font-size: 0.97rem;
            line-height: 1.5;
            margin-top: 4px;
          }
 
          .bio-diss strong {
            color: #7ecce6;
          }
 
          /* Mobile stacking */
          @media (max-width: 768px) {
            .author-hero {
              flex-direction: column;
              align-items: center;
            }
            .author-name-heading { font-size: 2rem; text-align: center; }
            .author-title-line   { text-align: center; }
          }
 
          /* ============================================================
             EXPANDABLE CONTENT PANELS (About This Work / Acknowledgements)
          ============================================================ */
          .about-expand-panel {
            border-radius: 16px;
            border: 1px solid rgba(126,204,230,0.18);
            background: rgba(15,31,45,0.55);
            margin-bottom: 14px;
            overflow: hidden;
          }
 
          .about-expand-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            cursor: pointer;
            user-select: none;
            transition: background 0.2s;
          }
 
          .about-expand-header:hover {
            background: rgba(126,204,230,0.07);
          }
 
          .about-expand-header h5 {
            margin: 0;
            color: #7ecce6;
            font-size: 1.05rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
          }
 
          .expand-chevron {
            color: rgba(126,204,230,0.70);
            transition: transform 0.3s ease;
            font-size: 0.9rem;
          }
 
          .about-expand-panel.open .expand-chevron {
            transform: rotate(180deg);
          }
 
          .about-expand-body {
            display: none;
            padding: 0 20px 18px 20px;
          }
 
          .about-expand-panel.open .about-expand-body {
            display: block;
          }
 
          .about-expand-body p {
            color: rgba(210,235,248,0.88);
            font-size: 0.97rem;
            line-height: 1.6;
            margin-bottom: 10px;
          }
 
          /* ============================================================
             MASONRY COLLAGE GALLERY
          ============================================================ */
          .masonry-gallery {
            column-count: 4;
            column-gap: 12px;
            margin-top: 8px;
          }
 
          @media (max-width: 1200px) { .masonry-gallery { column-count: 3; } }
          @media (max-width: 800px)  { .masonry-gallery { column-count: 2; } }
          @media (max-width: 500px)  { .masonry-gallery { column-count: 1; } }
 
          .masonry-item {
            break-inside: avoid;
            margin-bottom: 12px;
            border-radius: 14px;
            overflow: hidden;
            cursor: pointer;
            position: relative;
 
            /* Start invisible for scroll-reveal */
            opacity: 0;
            transform: translateY(22px);
            transition: opacity 0.55s ease, transform 0.55s ease,
                        box-shadow 0.2s ease;
            border: 1px solid rgba(126,204,230,0.10);
          }
 
          /* Revealed state (added by JS) */
          .masonry-item.revealed {
            opacity: 1;
            transform: translateY(0);
          }
 
          .masonry-item:hover {
            box-shadow: 0 10px 30px rgba(0,0,0,0.50);
            border-color: rgba(126,204,230,0.35);
          }
 
          .masonry-item img {
            width: 100%;
            display: block;
            border-radius: 14px;
            transition: transform 0.4s ease;
          }
 
          .masonry-item:hover img {
            transform: scale(1.03);
          }
 
          /* Hover overlay caption */
          .masonry-item .masonry-caption {
            position: absolute;
            inset: auto 0 0 0;
            padding: 28px 12px 10px 12px;
            background: linear-gradient(transparent, rgba(8,18,30,0.80));
            color: rgba(255,255,255,0.85);
            font-size: 0.80rem;
            font-style: italic;
            border-radius: 0 0 14px 14px;
            opacity: 0;
            transition: opacity 0.25s ease;
          }
 
          .masonry-item:hover .masonry-caption {
            opacity: 1;
          }
 
          /* ============================================================
             SLIDESHOW
          ============================================================ */
          .about-slideshow-wrap {
            position: relative;
            width: 100%;
            border-radius: 18px;
            overflow: hidden;
            background: #0a1520;
            aspect-ratio: 16 / 6;
          }
 
          .about-slide {
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity 0.9s ease;
          }
 
          .about-slide.active { opacity: 1; }
 
          .about-slide img {
            width: 100%; height: 100%;
            object-fit: cover; display: block;
          }
 
          .about-slide-caption {
            position: absolute;
            bottom: 0; left: 0; right: 0;
            padding: 12px 20px;
            background: linear-gradient(transparent, rgba(8,18,30,0.85));
            color: rgba(255,255,255,0.88);
            font-style: italic;
            font-size: 0.93rem;
          }
 
          .slideshow-dots {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
          }
 
          .slideshow-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: rgba(126,204,230,0.25);
            border: 1px solid rgba(126,204,230,0.45);
            cursor: pointer;
            transition: background 0.3s;
          }
 
          .slideshow-dot.active { background: #7ecce6; }
 
          .slideshow-arrow {
            position: absolute;
            top: 50%; transform: translateY(-50%);
            background: rgba(15,31,45,0.55);
            border: 1px solid rgba(126,204,230,0.28);
            color: #7ecce6;
            border-radius: 50%;
            width: 36px; height: 36px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; z-index: 10;
            transition: background 0.2s;
          }
 
          .slideshow-arrow:hover { background: rgba(15,31,45,0.85); }
          .slideshow-arrow.prev  { left: 14px; }
          .slideshow-arrow.next  { right: 14px; }
 
          /* ============================================================
             LIGHTBOX
          ============================================================ */
          .lb-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(4,10,20,0.94);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(8px);
          }
 
          .lb-overlay.open { display: flex; }
 
          .lb-inner {
            position: relative;
            max-width: 92vw;
            max-height: 90vh;
          }
 
          .lb-overlay img {
            max-width: 90vw;
            max-height: 88vh;
            border-radius: 16px;
            box-shadow: 0 24px 70px rgba(0,0,0,0.80);
            display: block;
          }
 
          .lb-close {
            position: fixed;
            top: 18px; right: 26px;
            color: rgba(255,255,255,0.70);
            font-size: 2.2rem;
            cursor: pointer;
            line-height: 1;
            z-index: 10000;
            transition: color 0.2s;
          }
 
          .lb-close:hover { color: #7ecce6; }
 
          /* ============================================================
             SECTION DIVIDER
          ============================================================ */
          .about-divider {
            height: 1px;
            background: linear-gradient(90deg,
              transparent, rgba(126,204,230,0.25), transparent);
            margin: 28px 0;
          }
 
          /* ============================================================
             CITATION BOX
          ============================================================ */
          .about-citation {
            border-radius: 14px;
            border: 1px solid rgba(126,204,230,0.20);
            background: rgba(15,31,45,0.45);
            padding: 18px 22px;
            text-align: center;
          }
 
          .about-citation p {
            color: rgba(200,230,245,0.80);
            font-size: 0.95rem;
            margin-bottom: 8px;
            line-height: 1.5;
          }
 
          .about-citation p:last-child { margin-bottom: 0; }
 
        ")),
        
        tags$script(HTML("
          $(document).ready(function() {
 
            /* ---- Accordion panels ---- */
            $('.about-expand-header').on('click', function() {
              $(this).closest('.about-expand-panel').toggleClass('open');
            });
 
            /* ---- Slideshow ---- */
            var slides = $('.about-slide');
            var dots   = $('.slideshow-dot');
            var cur = 0, timer;
 
            function goTo(n) {
              slides.eq(cur).removeClass('active');
              dots.eq(cur).removeClass('active');
              cur = (n + slides.length) % slides.length;
              slides.eq(cur).addClass('active');
              dots.eq(cur).addClass('active');
            }
 
            function autoPlay() {
              timer = setInterval(function(){ goTo(cur + 1); }, 4800);
            }
 
            function resetTimer() { clearInterval(timer); autoPlay(); }
 
            if (slides.length) { goTo(0); autoPlay(); }
 
            dots.on('click', function(){ goTo($(this).index()); resetTimer(); });
            $('#slide-prev').on('click', function(){ goTo(cur - 1); resetTimer(); });
            $('#slide-next').on('click', function(){ goTo(cur + 1); resetTimer(); });
 
            /* ---- Masonry scroll-reveal via IntersectionObserver ---- */
            if ('IntersectionObserver' in window) {
              var io = new IntersectionObserver(function(entries) {
                entries.forEach(function(entry, idx) {
                  if (entry.isIntersecting) {
                    var el = entry.target;
                    // stagger by position in the list
                    var delay = (Array.from(document.querySelectorAll('.masonry-item'))
                                  .indexOf(el) % 6) * 70;
                    setTimeout(function(){ el.classList.add('revealed'); }, delay);
                    io.unobserve(el);
                  }
                });
              }, { threshold: 0.08 });
 
              document.querySelectorAll('.masonry-item').forEach(function(el) {
                io.observe(el);
              });
            } else {
              // Fallback: reveal all immediately
              document.querySelectorAll('.masonry-item').forEach(function(el) {
                el.classList.add('revealed');
              });
            }
 
            /* ---- Lightbox ---- */
            $(document).on('click', '.masonry-item', function(){
              var src = $(this).find('img').attr('src');
              $('#lb-img').attr('src', src);
              $('#lb-overlay').addClass('open');
            });
 
            $('#lb-overlay').on('click', function(e){
              if (e.target === this) $(this).removeClass('open');
            });
 
            $('.lb-close').on('click', function(){
              $('#lb-overlay').removeClass('open');
            });
 
            $(document).on('keydown', function(e){
              if (e.key === 'Escape') $('#lb-overlay').removeClass('open');
            });
 
          });
        "))
      ),
      
      # ── Lightbox ──────────────────────────────────────────────────────────
      div(id = "lb-overlay", class = "lb-overlay",
          span(class = "lb-close", HTML("&times;")),
          div(class = "lb-inner",
              tags$img(id = "lb-img", src = "", alt = "")
          )
      ),
      
      # ── 1. HERO HEADER ────────────────────────────────────────────────────
      div(class = "hero-header",
          style = paste0(
            "background-image: linear-gradient(rgba(15,31,45,0.70),",
            " rgba(15,31,45,0.70)), url('restoration.jpg');"
          ),
          fluidRow(
            column(8,
                   h1("Vanessa M. Quintana",
                      class = "hero-title-overlay",
                      style = "font-size:2.6rem; margin-bottom:6px;"),
                   p("PhD Candidate · Marine Biology · University of Maine",
                     style = "color:rgba(255,255,255,0.88); font-size:1.1rem; margin-bottom:4px;"),
                   p("ORISE Ecological Modeling Fellow · U.S. Army Corps of Engineers",
                     style = "color:rgba(255,255,255,0.75); font-size:1rem; margin:0;")
            ),
            column(4,
                   div(style = "text-align:right; padding-top:14px;",
                       tags$a(
                         href  = "mailto:mahan.vanessa98@gmail.com",   # <- replace
                         class = "link-btn",
                         style = "font-size:1rem; padding:10px 22px; border-radius:12px;
                          background:rgba(79,179,217,0.32);
                          border:1px solid rgba(79,179,217,0.55);
                          color:#ffffff; text-decoration:none;",
                         tags$i(class = "bi bi-envelope-fill", style = "margin-right:8px;"),
                         "Get in Contact"
                       )
                   )
            )
          )
      ),
      
      # ── AUTHOR HERO SECTION ───────────────────────────────────────────────
      div(class = "author-hero",
          
          # Portrait column
          div(class = "author-portrait-col",
              div(class = "author-portrait-frame",
                  tags$img(
                    src   = "Author_Picture.jpg",
                    class = "author-portrait-img",
                    alt   = "Vanessa M. Quintana"
                  )
              ),
              
              # Credential badges
              div(class = "author-badges",
                  div(class = "author-badge",
                      tags$i(class = "bi bi-mortarboard-fill"),
                      "Marine Biology, University of Maine"
                  ),
                  div(class = "author-badge",
                      tags$i(class = "bi bi-shield-fill"),
                      "ORISE Fellow, U.S. Army Corps of Engineers"
                  ),
                  div(class = "author-badge",
                      tags$i(class = "bi bi-water"),
                      "Estuarine Hydrodynamics & Sediment Transport"
                  ),
                  div(class = "author-badge",
                      tags$i(class = "bi bi-diagram-3-fill"),
                      "Agent-Based & Numerical Modeling"
                  )
              ),
              
              # Social buttons
              div(class = "author-socials",
                  tags$a(
                    href = "https://github.com/vmahan1998",
                    target = "_blank", class = "author-social-btn",
                    tags$i(class = "bi bi-github"), "GitHub"
                  ),
                  tags$a(
                    href = "https://www.linkedin.com/in/vanessa-quintana-a775aa170/",
                    target = "_blank", class = "author-social-btn",
                    tags$i(class = "bi bi-linkedin"), "LinkedIn"
                  )
              )
          ),
          
          # Bio column
          div(class = "author-bio-col",
              tags$h5(
                tags$i(class = "bi bi-journal-text"), "About the Author"
              ),
              p(class = "bio-prose",
                "I am an ecological modeler with the U.S. Army Corps of Engineers
             and a PhD candidate in Marine Sciences at the University of Maine.
             I didn't come into coastal science through a traditional path, and
             a lot of my work has been shaped by learning how to navigate systems
             I was not originally trained in. That experience is part of why I
             focus on building tools that are accessible, transparent, and
             actually usable by the people making decisions."
              ),
              
              p(class = "bio-prose",
                "My work sits at the intersection of hydrodynamics, sediment and
             contaminant transport, and fish behavior. I am interested in how
             exposure actually happens in real systems, not just where contamination
             exists. I approach modeling as a way to make processes visible — to
             understand how movement, interaction, and environmental conditions
             combine to shape outcomes over time."
              ),
              
              div(class = "bio-diss",
                  tags$strong("Dissertation: "),
                  tags$em("Drivers of Sediment-Bound Contamination Risk for Anadromous
                     Fish in Estuaries as Derived from Observations on the
                     Penobscot River, Maine")
              ),
              
              div(class = "about-divider"),
              
              # Expandable: About This Work
              div(class = "about-expand-panel",
                  div(class = "about-expand-header",
                      tags$h5(
                        tags$i(class = "bi bi-journal-text"), "About This Work"
                      ),
                      tags$i(class = "bi bi-chevron-down expand-chevron")
                  ),
                  div(class = "about-expand-body",
                      p("The Penobscot River Estuary is a system where hydrodynamics,
                 sediment transport, and contamination are tightly coupled in ways
                 that directly structure exposure. A large, mobile pool of
                 contaminated sediments, combined with strong tidal forcing and
                 variable river discharge, results in mercury that is continuously
                 redistributed rather than fixed in space. This creates conditions
                 where exposure emerges as organisms move through shifting
                 contamination fields."),
                      p("At the same time, large-scale restoration is occurring alongside
                 active remediation and persistent fish consumption limitations.
                 Fish are returning to habitats that remain contaminated, creating
                 a disconnect between ecological recovery and usable access."),
                      p("Model development is structured through collaboration with
                 community partners, resource managers, and technical experts to
                 ensure that assumptions and outputs reflect real system
                 understanding and management priorities.")
                  )
              ),
              
              # Expandable: Lessons Learned
              div(class = "about-expand-panel",
                  div(class = "about-expand-header",
                      tags$h5(
                        tags$i(class = "bi bi-lightbulb"), "Lessons Learned"
                      ),
                      tags$i(class = "bi bi-chevron-down expand-chevron")
                  ),
                  div(class = "about-expand-body",
                      p("Exposure cannot be understood from environmental conditions alone.
                 Risk is dynamic and spatially variable — it emerges from the
                 interaction between hydrodynamics, sediment transport, and
                 organism movement."),
                      p("Restoration and remediation do not occur in isolation. In the
                 Penobscot system, fish are returning to habitats that remain
                 contaminated, creating a disconnect between ecological recovery
                 and safe or usable access."),
                      p("Risk is not experienced uniformly. Different species and life
                 stages encounter contamination through different pathways,
                 requiring pathway-specific understanding rather than a single
                 management metric."),
                      p("These insights reinforce the need for models grounded in local
                 knowledge and system understanding, with tools responsive to
                 community needs and decision contexts.")
                  )
              ),
              
              # Expandable: Acknowledgements
              div(class = "about-expand-panel",
                  div(class = "about-expand-header",
                      tags$h5(
                        tags$i(class = "bi bi-people-fill"), "Acknowledgements"
                      ),
                      tags$i(class = "bi bi-chevron-down expand-chevron")
                  ),
                  div(class = "about-expand-body",
                      
                      div(style = "text-align: center; margin-bottom: 1.2rem;",
                          p(tags$strong("Land Acknowledgement: "),
                            "This work was conducted within the Traditional Territory of the
           Penobscot Nation, whose stewardship of these lands and waters has
           sustained ecological and cultural knowledge for generations.
           The Penobscot River remains central to the identity, governance,
           and lifeways of the Penobscot people. I recognize and respect
           this enduring relationship and acknowledge that this work benefits
           from their continued presence, advocacy, and care for the river."),
                          p("The Penobscot Nation is connected to the broader Wabanaki Tribal
           Nations — the Passamaquoddy, Maliseet, and Mi'kmaq — through
           kinship, alliances, and shared histories. These Nations are
           distinct, sovereign entities with their own systems of governance
           and knowledge.",
                            style = "font-size:0.92rem; color:rgba(200,225,240,0.70);")
                      ),
                      
                      tags$hr(),  # divider between tribal acknowledgement and rest
                      
                      p(tags$strong("Advisory Committee: "),
                        "Dr. Kimberly Huguenard, Dr. Damian Brady, Dr. Gayle Zydlewski,
                 Dr. Kyle McKay, Justin Stevens, Dr. Todd Swannack"),
                      p(tags$strong("Data & Technical Contributions: "),
                        "Dianne Kopec (mercury data), Jarrell Smith (MATLAB calibration),
                 Dr. Lauren Ross (temperature data), Nalika Lakmali
                 (ADCP processing and Delft3D modeling)"),
                      p(tags$strong("Field & Laboratory Support: "),
                        "Nick Cyr, Dr. Nyxen Fisher"),
                      p(tags$strong("Ecological Knowledge & Model Evaluation: "),
                        "Andrew Jacobs, Andrea Casey"),
                      p(tags$strong("Workshop Facilitation: "),
                        "Katrina Armstrong, Dr. Gayle Zydlewski"),
                      p(tags$strong("Workshop Participants: "),
                        "Ernie Atkinson, Andrea Casey, Devon Gleason, Heather Hamlin,
                 John Hildebrand, Dan Kircheis, Dianne Kopec, John Kocik,
                 Dan Kusnierz, Chuck Loring, Dan McCaw, Amelia McAvoy,
                 Sasha Milsky, Elias Pinilla, Darren Ranco, Angie Reed,
                 Lauren Ross, Justin Stevens, Joe Zydlewski"),
                      p(tags$strong("Workshop Volunteers: "),
                        "Nicolas Cyr, Saba Cyr, Katherine Daza, Joseph Dello Russo,
                 Nalika Lakmali, Cristian Rojas, Malavika Sudhakaran, Kaylyn Zipp"),
                      p(tags$strong("Institutional Support: "),
                        "University of Maine and the U.S. Army Engineer Research and
                 Development Center (ERDC)")
                  )
              )
              
          ) # end bio col
      ), # end author hero
      
      div(class = "about-divider"),
      
      # ── SLIDESHOW ─────────────────────────────────────────────────────────
      h4("Field & Lab",
         style = "color:#7ecce6; font-weight:700; font-size:1.3rem;
                  letter-spacing:0.2px; margin-bottom:14px;"),
      
      div(class = "about-slideshow-wrap",
          div(id = "slide-prev", class = "slideshow-arrow prev",
              tags$i(class = "bi bi-chevron-left")),
          
          div(class = "about-slide active",
              tags$img(src = "PXL_20230929_104648771.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Early morning fog on the Penobscot River — fall sampling, October 2023")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20230929_104901566.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Heading upriver through morning mist — Penobscot River Estuary, fall 2023")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20240814_172627809.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Summer 2024 field campaign with the research team — Penobscot River")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20240814_172511419.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Navigating the upper Penobscot during summer low-flow conditions — August 2024")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20231013_104559370.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Derelict vessel along the estuarine shoreline — a marker of the river's industrial history")
          ),
          div(class = "about-slide",
              tags$img(src = "restoration.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "The upper Penobscot restoration reach — formerly impounded, now free-flowing")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20231002_140453696.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Labeled water samples awaiting analysis — University of Maine lab, fall 2023")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20230906_161440467.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Suspended sediment on a membrane filter — grain-size analysis pipeline")
          ),
          div(class = "about-slide",
              tags$img(src = "IMG_9487.JPG", alt = ""),
              div(class = "about-slide-caption",
                  "Presenting hydrodynamic model results to tribal and agency partners — stakeholder workshop")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20240815_160038102.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Looking out across the lower Penobscot Estuary — August 2024")
          ),
          div(class = "about-slide",
              tags$img(src = "PXL_20240814_175748230.jpg", alt = ""),
              div(class = "about-slide-caption",
                  "Derelict fishing vessel — summer 2024")
          ),
          
          div(id = "slide-next", class = "slideshow-arrow next",
              tags$i(class = "bi bi-chevron-right"))
      ),
      
      div(class = "slideshow-dots",
          lapply(seq_len(11), function(i)
            div(class = if (i == 1) "slideshow-dot active" else "slideshow-dot")
          )
      ),
      
      div(class = "about-divider"),
      
      # ── CITATION ──────────────────────────────────────────────────────────
      div(class = "about-citation",
          p("This application accompanies a doctoral dissertation and is intended
           for research communication and transparency. Please cite the
           dissertation or associated publications when using figures or
           concepts from this application."),
          p(
            tags$strong("Quintana, V. M."),
            " (in prep). ",
            tags$em("Drivers of Sediment-Bound Contamination Risk for Anadromous
                   Fish in Estuaries as Derived from Observations on the
                   Penobscot River, Maine."),
            " Doctoral dissertation, University of Maine."
          )
      ),
      
      div(class = "about-divider"),
      
      
      # ── MASONRY COLLAGE GALLERY ───────────────────────────────────────────
      h4("Gallery",
         style = "color:#7ecce6; font-weight:700; font-size:1.3rem;
                  letter-spacing:0.2px; margin-bottom:14px;"),
      
      div(class = "masonry-gallery",
          local({
            photos <- list(
              list(src = "PXL_20230929_104648771.jpg",          cap = "Foggy morning, Penobscot River — fall 2023"),
              list(src = "PXL_20230929_104901566.jpg",          cap = "River wake at dawn — fall 2023"),
              list(src = "PXL_20240814_172627809.jpg",          cap = "Field team underway — August 2024"),
              list(src = "PXL_20240814_172511419.jpg",          cap = "Upper Penobscot, summer low-flow"),
              list(src = "PXL_20231013_104559370.jpg",          cap = "Derelict vessel — autumn"),
              list(src = "restoration.jpg",                      cap = "Restored river reach, upper Penobscot"),
              list(src = "PXL_20231002_140453696.jpg",          cap = "Water samples, UMaine lab — fall 2023"),
              list(src = "PXL_20230906_161440467.jpg",          cap = "Sediment filter — grain size analysis"),
              list(src = "IMG_9487.JPG",                        cap = "Stakeholder workshop presentation"),
              list(src = "PXL_20240815_160038102.jpg",          cap = "Open estuary from the bow — August 2024"),
              list(src = "PXL_20240814_175748230.jpg",          cap = "Derelict fishing vessel — summer 2024"),
              list(src = "PXL_20230915_225121190.jpg",          cap = "Field work — September 2023"),
              list(src = "PXL_20230915_225155881~2.jpg",        cap = "Field work — September 2023"),
              list(src = "PXL_20230929_083537181.NIGHT(1).jpg", cap = "Night on the Penobscot River"),
              list(src = "PXL_20230929_104536477.jpg",          cap = "River sampling — fall 2023"),
              list(src = "PXL_20230929_104601490.jpg",          cap = "River sampling — fall 2023"),
              list(src = "PXL_20231013_105338630.jpg",          cap = "Field site — October 2023"),
              list(src = "PXL_20230825_153916481.jpg",          cap = "Field work — August 2023"),
              list(src = "PXL_20230901_163228235.jpg",          cap = "Field work — September 2023"),
              list(src = "PXL_20230906_160938626.jpg",          cap = "Field work — September 2023"),
              list(src = "IMG_9200.JPG",  cap = "Field photo"),
              list(src = "IMG_9201.JPG",  cap = "Field photo"),
              list(src = "IMG_9211.JPG",  cap = "Field photo"),
              list(src = "IMG_9212.JPG",  cap = "Field photo"),
              list(src = "IMG_9240.JPG",  cap = "Field photo"),
              list(src = "IMG_9263.JPG",  cap = "Field photo"),
              list(src = "IMG_9265.JPG",  cap = "Field photo"),
              list(src = "IMG_9271.JPG",  cap = "Field photo"),
              list(src = "IMG_9278.JPG",  cap = "Field photo"),
              list(src = "IMG_9281.JPG",  cap = "Field photo"),
              list(src = "IMG_9283.JPG",  cap = "Field photo"),
              list(src = "IMG_9294.JPG",  cap = "Field photo"),
              list(src = "IMG_9301.JPG",  cap = "Field photo"),
              list(src = "IMG_9308.JPG",  cap = "Field photo"),
              list(src = "IMG_9310.JPG",  cap = "Field photo"),
              list(src = "IMG_9314.JPG",  cap = "Field photo"),
              list(src = "IMG_9327.JPG",  cap = "Field photo"),
              list(src = "IMG_9331.JPG",  cap = "Field photo"),
              list(src = "IMG_9335.JPG",  cap = "Field photo"),
              list(src = "IMG_9346.JPG",  cap = "Field photo"),
              list(src = "IMG_9348.JPG",  cap = "Field photo"),
              list(src = "IMG_9368.JPG",  cap = "Field photo"),
              list(src = "IMG_9383.JPG",  cap = "Field photo"),
              list(src = "IMG_9405.JPG",  cap = "Field photo"),
              list(src = "IMG_9419.JPG",  cap = "Field photo"),
              list(src = "IMG_9434.JPG",  cap = "Field photo"),
              list(src = "IMG_9455.JPG",  cap = "Field photo"),
              list(src = "IMG_9528.JPG",  cap = "Field photo"),
              list(src = "IMG_9534.JPG",  cap = "Field photo"),
              list(src = "IMG_9541.JPG",  cap = "Field photo"),
              list(src = "IMG_9552.JPG",  cap = "Field photo"),
              list(src = "IMG_9553.JPG",  cap = "Field photo"),
              list(src = "IMG_9571.JPG",  cap = "Field photo"),
              list(src = "1000016621.jpg", cap = "Field photo"),
              list(src = "1000016639.jpg", cap = "Field photo"),
              list(src = "1000016640.jpg", cap = "Field photo")
            )
            
            lapply(photos, function(p) {
              div(class = "masonry-item",
                  tags$img(src = p$src, alt = p$cap, loading = "lazy"),
                  div(class = "masonry-caption", p$cap)
              )
            })
          })
      ),
      
      div(class = "section-space")
      
    ) # end fluidPage
  ) # end tabPanel
}


# ── SERVER ────────────────────────────────────────────────────────────────────
tab_about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # All interactivity is pure JS — extend here if needed.
  })
}