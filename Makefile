MAIN = cv
DOCKER_IMAGE = ghcr.io/xu-cheng/texlive-full:latest

.PHONY: all docker clean

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex
	pdflatex $(MAIN).tex
	pdflatex $(MAIN).tex

docker:
	docker run --rm -v $(PWD):/workspace -w /workspace $(DOCKER_IMAGE) latexmk -pdf $(MAIN).tex

clean:
	rm -f *.aux *.log *.out *.synctex.gz *.fls *.fdb_latexmk $(MAIN).pdf
