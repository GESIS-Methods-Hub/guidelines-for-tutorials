# Methods Hub's Guidelines for Tutorials

Here you will find the guidelines used by Methods Hub for tutorials. If you are preparing a method, check the [guidelines used by Methods Hub for methods](https://github.com/GESIS-Methods-Hub/guidelines-for-methods).

A tutorial is an instructional resource that may be used as a part of a self-guided learning process. Tutorials on the Methods Hub should focus on very concrete tasks and offer code that helps researchers to solve the task. This could be via applications of methods that are featured on the Methods Hub, but could also refer to methods publised elsewhere. A tutorial can feature more than one method. Tutorials will be prefaced with what prior knowledge is expected from the user such that the user can judge themselves if they have the required skills to follow the tutorial.

At [Methods Hub's Taxonomy](https://methodshub.gesis.org/about/how-to-submit/taxonomy) you find an overview of tasks for which Methods Hub welcomes tutorials.

<!--
The checklist will be here
--->

## Accepted formats 

| Format | File extension | Notes |
| --- | --- | --- |
| [Quarto](https://quarto.org/) | `.qmd` | |
| [Jupyter Notebook Format](https://nbformat.readthedocs.io/en/latest/index.html) | `.ipynb` | Limited to a single programming language. |
| [R Markdown](https://rmarkdown.rstudio.com/) | `.rmd` | If possible, should be ported to Quarto. |
| [(Pandoc) Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) | `.md` | |

## Required Files

The Git repository with the tutorial **must** have the following files

- [`README.*`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
- [`LICENSE.*`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
- [`CITATION.cff`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-citation-files)

Additionally, the Git repository **must** also have the [necessary files for setting up a binder environment](https://mybinder.readthedocs.io/en/latest/using/config_files.html)used for rendering the tutorial. These binder configuration files can be located at the root level or in a directory named `.binder` or `binder`. In the following sections, we will assume these files to be located in `binder`.

Specifically for the Methods Hub, the following files **must** be available among the binder configuration files:

1. `binder/postBuild` file that facilitates Quarto installation. The `postBuild` can be downloaded from https://methodshub.gesis.org/snippet/postBuild/.
2. configuration files that record the computational environment, e.g. dependencies. See the following sections on how to create these files for different programming languages.

### Python

Create `binder/requirements.txt` using `pip`.

```bash
python3 -m pip freeze > binder/requirements.txt
```

The `binder/requirements.txt` should look like [`binder-examples/python/requirements.txt`](binder-examples/python/requirements.txt).

It is strongly recommended to pin the version of the dependencies.

### R

`install.packages()` or similar commands for installing R packages (e.g. `pak::pkg_install()`, `devtools::install_github()`) should **not** be called from the tutorial source file (e.g. `qmd`, `rmd`, or `.ipynb`).

Instead, create `binder/runtime.txt` (which contains the current R version and a snapshot date) and `binder/install.R`.

```bash
## Record the current R version and use the current date as the snapshot date
Rscript -e "writeLines(paste0('r-', getRversion(), '-', format(Sys.time(), '%Y-%m-%d')), 'binder/runtime.txt')" 
```

And add `install.packages()` calls to `binder/install.R`. The `binder/install.R` should look like [`binder-examples/r/install.R`](binder-examples/r/install.R).

Although allowed, there are no need to pin the version with tools such as `renv` because [P3M](https://posit.co/products/cloud/public-package-manager/) is used when creating a binder environment. It will install the latest version of R packages according to the snapshot date recorded in `runtime.txt`.

If there is a need to illustrate the installation process using `install.packages()` or similar commands for installing R packages, set the code block to `eval: false` as illustrated in [`template.qmd`](template.qmd).

### Many languages (conda)

If you use `conda` to configure your computational environment, create `binder/environment.yml` with

```bash
## Export the current active environment
conda env export > binder/environment.yml
```

or

```bash
## Export a specific environment, e.g. environment-name
conda env export -n environment-name > binder/environment.yml
```

The `binder/environment.yml` should look like [`binder-examples/conda/environment.yml`](binder-examples/conda/environment.yml).

It is strongly recommended to pin the version of the dependencies.

## Structure of tutorial source file

There are some suggested headings. See [`template.qmd`] and [`template.ipynb`] for the suggested headings.

## HTML Rendering

All submitted tutorials will be converted (or rendered) to HTML by Methods Hub using [Quarto]. The HTML version is included in the tutorial's landing page on Methods Hub.

Before submitting the tutorial, please test the rendering offline and check the HTML file produced.

### Rendering a Quarto document

If you use [`template.qmd`], you can get both HTML (for preview) and `ipynb` by running:

```sh
## assume you have not renamed the file
quarto render template.qmd
```

Please then check the converted HTML file.

### Rendering a Jupyter notebook

Jupyter notebooks are rendered into HTML with [Quarto] using the Jupyter kernel. Comparing to native `.qmd` documents, the following features are not supported.

* BibTex citation and bibliography (you have to do citation manually, this method does not work for [HTML rendering](https://nbviewer.org/github/jupyter/nbconvert-examples/blob/master/citations/Tutorial.ipynb))
* Cross referencing

Please also note how to handle the [YAML Front Matter](https://quarto.org/docs/tools/jupyter-lab.html#yaml-front-matter) for notebook. An example is provided in [`template.ipynb`].

It can be rendered with quarto like so:

```sh
quarto render notebook.ipynb --execute
```

Please then check the converted HTML file.

<!-- ## Conversion -->

<!-- Methods Hub uses `quarto` to do the conversion. You can try the same conversion yourself. -->

<!-- `qmd` to `ipynb` -->

<!-- ```sh -->
<!-- quarto convert input.qmd --output output.ipynb -->
<!-- ``` -->

<!-- `ipynb` to `qmd` -->

<!-- ```sh -->
<!-- quarto convert input.ipynb --output output.qmd -->
<!-- ``` -->

<!-- See [`conv.sh`](conv.sh) on how to convert [an existing `ipynb`-based tutorial](https://github.com/gesiscss/css_methods_python/tree/main/b_data_collection_methods) to quarto and back. See also the note about code execution below. -->

#### Caution: Code execution by `knitr` and `jupyter`

There is one subtle, but important, difference between the code execution between `knitr` (the default renderer for R code in `quarto`) and jupyter. For example, this R code block (see the provided file `code_exec.qmd`)

````
```{r}
mean(mtcars$mpg)
plot(mtcars$mpg, mtcars$wt)
```
````

When rendering this into notebook by [Quarto] using

```sh
quarto render code_exec.qmd --to=ipynb
```

All code blocks will be rendered but also will get modified with the plotting line removed. It's not ideal. So, there two ways to fix this:

Convert it is by using `quarto convert` instead to generate an empty ipynb.

```sh
quarto convert code_exec.qmd -o code_exec.ipynb
```

Or, to split the code block into one line per block. And for the plot code, you must add the execution option. Only in this case, `quarto render` will not eat the visualization code.

````
```{r}
mean(mtcars$mpg)
```

```{r}
#| echo: true
plot(mtcars$mpg, mtcars$wt)
```
````

[Quarto]: https://quarto.org/
[`template.qmd`]: template.qmd
[`template.ipynb`]: template.ipynb
