# MH Tutorial Preparation Guide

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

## Headings

There are some suggested headings. See [`template.qmd`](template.qmd) for the suggested headings.

## Reproducibility

![](img/andrew-content.png)

[image source](https://github.com/GESIS-Methods-Hub/andrew/blob/main/img/andrew-content.png)

All submitted tutorials will be converted to both `.html` and `.ipynb` by [magdalena](https://github.com/gesiscss/magdalena) using [Quarto](https://quarto.org/).

The `.html` version is used as the landing page on Methods Hub.

The `.ipynb` version is available for download from Methods Hub.

## Use the template

If you use the `quarto` template above, you can get both HTML (for preview) and `ipynb` by running:

```sh
quarto render template.qmd
```

## Conversion

Content converstion `magdalena` uses `quarto` to do the conversion. You can try the same conversion yourself.

`qmd` to `ipynb`

```sh
quarto convert input.qmd --output output.ipynb
```

`ipynb` to `qmd`

```sh
quarto convert input.ipynb --output output.qmd
```

See [`conv.sh`](conv.sh) on how to convert [an `ipynb`-based tutorial](https://github.com/gesiscss/css_methods_python/tree/main/b_data_collection_methods) to quarto and back. See also the note about code execution below.

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
