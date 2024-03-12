## Clone
git clone https://github.com/gesiscss/css_methods_python.git

## Create a quarto project called "demo" and remove the default quarto docu
quarto create project default demo --no-open
rm demo/Demo.qmd
tree demo

## Copy the files we need
## For demo, I am using the easiest case
cp css_methods_python/b_data_collection_methods/2_data_parsing_and_static_web_scraping.ipynb demo
cp -r css_methods_python/b_data_collection_methods/images demo

## Convert the ipython notebook to quarto
quarto convert demo/2_data_parsing_and_static_web_scraping.ipynb --output demo/Demo.qmd

## Create the directory required for the rendering (it is because of the code in the notebook)
mkdir demo/results

## Optional: Replace line556; just don't like lxml
sed -i "556s/.*/soup = BeautifulSoup(page.content,'html5lib')/" demo/Demo.qmd

## Render the quarto
quarto render demo/Demo.qmd

## Open it
## xdg-open demo/Demo.html

## adding binder infra
## You still need either requirements.txt or environment.yaml
## https://mybinder.readthedocs.io/en/latest/using/config_files.html
cd demo; quarto use binder --no-prompt; cd ..

## Render the quarto back as ipynb
cd demo; quarto render Demo.qmd -o Demo2.ipynb --to=ipynb
## jupyter notebook Demo2.ipynb
