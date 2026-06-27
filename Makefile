MAIN = cv
NAME = Ismael_Ares_Fagil_CV
DOCKER_IMAGE = ghcr.io/xu-cheng/texlive-full:latest

.PHONY: all docker clean

all: $(NAME).pdf

$(NAME).pdf: $(MAIN).tex
	pdflatex -jobname=$(NAME) $(MAIN).tex
	pdflatex -jobname=$(NAME) $(MAIN).tex

docker:
	docker run --rm -v $(PWD):/workspace -w /workspace $(DOCKER_IMAGE) latexmk -pdf -jobname=$(NAME) $(MAIN).tex

clean:
	rm -f *.aux *.log *.out *.synctex.gz *.fls *.fdb_latexmk $(NAME).pdf
