# MH Tutorial Preparation Guide (CSS)

# Accepted formats 

With code execution

* `qmd` [Quarto](https://quarto.org/) (Highly recommended)
* `ipynb` Jupyter Notebook (Preferred)
* `rmd` RMarkdown

Without code execution (e.g. web tools)

* Markdown
* Word

# Headings

There are some suggested headings. [Template](template.qmd) for those headings is available for `quarto`.

# Reproducibility

![](img/andrew-content.png)

[image source](https://github.com/GESIS-Methods-Hub/andrew/blob/main/img/andrew-content.png)

All submitted tutorials will be converted to both `qmd` and `ipynb` by [magdalena](https://git.gesis.org/methods-hub/magdalena) [^1]. It is (more) important to make sure that the `qmd` version can be rendered correctly as it is used for rendering the HTML version on MH.

The `ipynb` version is available for download. Also, it will be used mostly for launching the tutorial on Binder (see below).

## Use the template

If you use the `quarto` template above, you can get both HTML (for preview) and `ipynb` by running:

```sh
quarto render template.qmd
```

## Conversion

Content aggregator `magdalena` uses `quarto` to do the conversion. You can try the same conversion yourself.

`qmd` to `ipynb`

```sh
quarto convert input.qmd --output output.ipynb
```

`ipynb` to `qmd`

```sh
quarto convert input.ipynb --output output.qmd
```

See [`conv.sh`](conv.sh) on how to convert [an `ipynb`-based tutorial](https://github.com/gesiscss/css_methods_python/tree/main/b_data_collection_methods) to quarto and back.

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

It will generate several files, e.g. `runtime.txt`, `postbuild`, `apt.txt`. You may still need to produce the [configuration files](https://mybinder.readthedocs.io/en/latest/using/config_files.html). For Python, you can use `requirements.txt` or `environment.yml` (conda). For R, you need to provide a file called `install.R` with `install.packages()` calls. In most of the cases, you do not need to pin the version (e.g. with tools such as `renv`) because [3PM](https://posit.co/products/cloud/public-package-manager/) is used. It will install the latest version of R packages according to the snapshot date recorded in `runtime.txt`.

You can check whether your tutorial is binder compatible by pushing your tutorial to GitHub (other options are also available) and launch it with [this form](https://mybinder.org/).

This is [an example](https://github.com/chainsawriot/methodshub-weat).

---

[^1]: Access to the code of magdalena is not public.
