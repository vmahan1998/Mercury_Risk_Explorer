# Mercury Risk Explorer

This repository contains the R/Shiny source code and web assets for the **Mercury Risk Explorer**, an interactive research-communication application focused on mercury-associated exposure risk in the Penobscot River Estuary, Maine.

**Public application:** <https://vkzfr3-vanessa-mahan.shinyapps.io/Mercury_Risk_Explorer/>

The application was developed as a community-facing companion to dissertation research. It is intended to make modeled relationships among estuarine material transport, mercury contamination, habitat, and fish behavior easier to explore and discuss.

## Application contents

The current application includes the following sections:

- **Home:** Purpose, geographic context, conceptual overview, and statement of use.
- **Mercury in the Penobscot River Estuary:** Background on legacy mercury contamination, mercury and methylmercury, estuarine processes, and exposure pathways.
- **Material Transport & Retention:** Hydrodynamic conditions, tidal and river-driven transport, suspended particulate matter, sediment mobilization, and retention at the Bangor and Hampden sites.
- **Habitat-Associated Risk:** Modeled habitat suitability and potential contamination risk across river-herring life stages.
- **Behavior-Mediated Risk:** Results from the Penobscot Mercury Exposure Model (P-MEM), a coupled hydrodynamic and agent-based modeling framework for alewives and striped bass under controlled predation scenarios.
- **About the Author:** Author information, acknowledgements, and selected references.

The migratory-fish tab is retained in the source tree but is not currently enabled in `app.R`.

## Repository contents

- `app.R` - Shiny application entry point, package imports, navigation, and server wiring.
- `R/` - UI and server modules for the application tabs.
- `www/` - Images, figures, icons, and custom web styling served by Shiny.
- `format.css` and `www/custom.css` - Application styling.
- `data/` - Local runtime inputs used by the application. These files are not included in the public Zenodo data release described below.

## Running locally

The application was developed for R and RStudio. To run it locally:

1. Obtain the application source code and the separately managed runtime data package.
2. Recreate the relative directory structure expected by the code, including `data/ABM`, `data/Bangor`, `data/Hampden`, and `data/Habitat`.
3. Open `Penobscot_Web_App.Rproj` in RStudio.
4. Install the required R packages:

```r
install.packages(c(
  "shiny", "bslib", "leaflet", "terra", "dplyr", "R.matlab",
  "fontawesome", "readr", "ggplot2", "plotly", "shinyjs", "sf",
  "sp", "ggridges", "scales", "lubridate", "data.table"
))
```

The application also uses the `HatchedPolygons` package. Install it from GitHub if it is not already available:

```r
remotes::install_github("statnmap/HatchedPolygons")
```

Then run `app.R` from the project root, or use:

```r
shiny::runApp()
```

The working directory must be the project root because the application uses relative paths for its data and web assets.

## Data availability

The underlying data are intentionally **not uploaded to the public repository or to Zenodo with this README**. The data include model outputs, field and validation data, spatial layers, and other runtime inputs that are managed separately from the public source-code documentation.

Because the application reads these files during startup and during visualization, a complete local deployment requires an authorized copy of the corresponding data package. The public Shiny deployment may contain the runtime data needed to operate the hosted application, but the data should not be inferred to be openly downloadable or redistributable.

The application uses several input formats, including:

- CSV and RDS files for model summaries, validation data, temporal risk profiles, and scenario results.
- MATLAB MAT files for hydrodynamic time series and material-transport results.
- Raster and vector spatial data for contaminant and habitat displays.
- Image assets and figures stored in `www/`.

## Interpretation and limitations

Outputs shown in the application are simulated estimates and spatial overlays generated from calibrated hydrodynamic and ecological models. They are conditional on the assumptions, parameters, behavioral rules, environmental forcing, and scenario configurations used in the analyses.

The visualizations should not be interpreted as direct observations or definitive predictions of fish behavior, habitat use, contaminant exposure, mercury toxicity, or mercury methylation rates. Results are provided for research communication, transparency, education, and discussion of potential ecological patterns and exposure pathways.

## Citation

When referring to the application or this source package, please cite the associated dissertation and the Zenodo record containing this README and source materials:

> Quintana, V., & Huguenard, K. (2026). Mercury Risk Explorer: An interactive Shiny application for exploring mercury-associated risk in the Penobscot River Estuary. (Version beta) [Computer software]. Zenodo. https://doi.org/10.5281/ZENODO.22031191

Please replace the placeholder citation and DOI after the Zenodo record is published. The application itself is available at the public URL listed above.

## Contact

See the **About the Author** section of the application for author information and contact details.