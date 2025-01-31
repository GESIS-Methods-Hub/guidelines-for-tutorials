# Methods Hub's Guidelines for Tutorials

Here you will find the guidelines used by Methods Hub for tutorials.
If you are preparing a method,
check the [guidelines used by Methods Hub for methods](https://github.com/GESIS-Methods-Hub/guidelines-for-methods).

## Accepted formats 

### With code execution

| Format | File extension | Notes |
| --- | --- | --- |
| [Quarto](https://quarto.org/) | `.qmd` | |
| [Jupyter Notebook Format](https://nbformat.readthedocs.io/en/latest/index.html) | `.ipynb` | Limited to a single programming language. |
| [R Markdown](https://rmarkdown.rstudio.com/) | `.rmd` | If possible, should be ported to Quarto. |

### Without code execution

For example, web tools.

| Format | File extension | Notes |
| --- | --- | --- |
| [Quarto](https://quarto.org/) | `.qmd` | Preferable format as it supports [citations](https://quarto.org/docs/authoring/footnotes-and-citations.html) and [cross references](https://quarto.org/docs/authoring/cross-references.html). |
| [(Pandoc) Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) | `.md` | |
| Microsoft Word | `.docx` | Not fully supported. |

## Required Files

The Git repository with the method **must** have the following files

- [`README.*`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
- [`LICENSE.*`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
- [`CITATION.cff`](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-citation-files)

Additionally, the Git repository **must** also have the [necessary files for setting up a binder environment](https://mybinder.readthedocs.io/en/latest/using/config_files.html)[^1]. For example,

- `binder/postBuild`
- `binder/environment.yml`

## Headings

There are some suggested headings. See [`template.qmd`](template.qmd) and [`template.ipynb`](template.ipynb) for the suggested headings.

## Reproducibility

All submitted tutorials will be converted to HTML by Methods Hub using [Quarto](https://quarto.org/). The HTML version is included in the tutorial's landing page on Methods Hub.

## Use the template

If you use the `quarto` template above, you can get both HTML (for preview) and `ipynb` by running:

```sh
quarto render template.qmd
```

## Use the Jupyter notebook template

Jupyter notebooks are rendered into HTML with quarto using the Jupyter kernel. Comparing to native quarto documents, the following features are not supported.

* BibTex citation and bibliography (you have to do citation manually, this method does not work for [HTML rendering](https://nbviewer.org/github/jupyter/nbconvert-examples/blob/master/citations/Tutorial.ipynb))
* Cross referencing

Please also note how to handle the [YAML Front Matter](https://quarto.org/docs/tools/jupyter-lab.html#yaml-front-matter) for notebook. An example is provided in [`template.ipynb`](template.ipynb).

It can be rendered with quarto like so:

```sh
quarto render notebook.ipynb --execute
```

## Conversion

Methods Hub uses `quarto` to do the conversion. You can try the same conversion yourself.

`qmd` to `ipynb`

```sh
quarto convert input.qmd --output output.ipynb
```

`ipynb` to `qmd`

```sh
quarto convert input.ipynb --output output.qmd
```

See [`conv.sh`](conv.sh) on how to convert [an existing `ipynb`-based tutorial](https://github.com/gesiscss/css_methods_python/tree/main/b_data_collection_methods) to quarto and back. See also the note about code execution below.

## Binder compatibility

`quarto` can make your tutorial [Binder](https://mybinder.org) compatible. But you should have `_quarto.yml` in the same directory, i.e. it is a [quarto project](https://quarto.org/docs/projects/quarto-projects.html).

You can initialize a project by:

```sh
## replace `projectname` with something else
quarto create projectname
cd projectname
```

Suppose you have put your tutorial and its associated files in that directory.

```sh
quarto use binder
```

It will generate several files, e.g. 

* `runtime.txt` ([example](https://github.com/chainsawriot/methodshub-weat/blob/v0.0/runtime.txt), it configures the run time environment, e.g. `r-4.3.3-2024-02-29`)
* `apt.txt` ([example](https://github.com/chainsawriot/methodshub-weat/blob/v0.0/apt.txt), it configures the system requirements)
* `postbuild` ([example](https://github.com/chainsawriot/methodshub-weat/blob/v0.0/postBuild), it configures the additional tools such as quarto)

You may still need to produce the [configuration files](https://mybinder.readthedocs.io/en/latest/using/config_files.html). For Python, you can use `requirements.txt` or `environment.yml` (conda). For R, you need to provide a file called `install.R` with `install.packages()` calls ([example](https://github.com/chainsawriot/methodshub-weat/blob/v0.0/install.R)). In most of the cases, you do not need to pin the version (e.g. with tools such as `renv`) because [3PM](https://posit.co/products/cloud/public-package-manager/) is used. It will install the latest version of R packages according to the snapshot date recorded in `runtime.txt`.

You can check whether your tutorial is binder compatible by pushing your tutorial to GitHub (other options are also available) and launch it with [this form](https://mybinder.org/).

This is [an example](https://github.com/chainsawriot/methodshub-weat).

## Caution: Code execution by knitr and jupyter

There is one subtle, but important, difference between the code execution between `knitr` (the default renderer for R code in `quarto`) and jupyter. For example, this R code block (see the provided file `code_exec.qmd`)

````
```{r}
mean(mtcars$mpg)
plot(mtcars$mpg, mtcars$wt)
```
````

When rendering this into notebook by quarto using

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

[^1]: That environment will be used for rendering the tutorial and for the interactive execution.