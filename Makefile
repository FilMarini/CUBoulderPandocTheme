template := template

export TEXINPUTS:=.:./$(template):${TEXINPUTS}

notedir := .
notes := $(wildcard $(notedir)/*.md)
notes := $(filter-out ./README.md, $(notes))
slides_tex := $(patsubst $(notedir)/%.md,%.tex,$(notes))
slides_pdf := $(patsubst %.tex,%.pdf,$(slides_tex)) 
slides_key := $(patsubst %.pdf,%.key,$(slides_pdf)) 
image_dirs = images/drawio
images_files := $(foreach dir,$(image_dirs),$(wildcard $(image_dirs)/*.drawio))
image_targets = $(patsubst %.drawio,%.pdf, $(images_files))
echoing:
	@echo "test" $(image_targets)
	@echo $(notes)
ima:
	if [ -d "$(image_dirs)" ]; then \
		$(MAKE) -C $(image_dirs) all; \
	fi

$(slides_tex): %.tex: $(notes)
	pandoc $< \
      --from markdown+grid_tables \
	    -t beamer \
	    --slide-level 2 \
	    -s \
	    --template=$(template)/template.latex \
	    --filter $(template)/bin/overlay_filter \
	    -V themeoptions:block=fill \
	    -o $@

$(slides_pdf): %.pdf: %.tex ima
	latexmk -xelatex $(basename $<)

# if you don't have Keynote or don't want to generate the Keynote file
# but want to avoid errors when you use "make all" (the default),
# just set the slides_key variable to nothing by uncommenting this line:
#
# slides_key :=

$(slides_key): %.key: %.pdf
	rm -f $@
	open -a "PDF To Keynote" $<
	osascript -e 'tell application "PDF To Keynote"' \
	    -e 'save document 1 in "$(abspath ./$(basename $@))"' \
	    -e 'end tell'

all: $(slides_pdf)

all_key: $(slides_key)

# clean up everything except pdfs and keynote files 
clean:
	latexmk -c
	rm -rf *.nav *.snm *.pdf *.xdv auto *.vrb
	rm -rf $(slides_tex)
	if [ -d	"$(image_dirs)" ]; then \
		$(MAKE) -C $(image_dirs) clean; \
	fi

# clean up everything including pdfs and keynote files 
reallyclean:
	latexmk -C
	rm -rf $(slides_tex)
	rm -rf *.nav *.snm  *.log auto
	rm -rf $(slides_key)
	if [ -d	"$(image_dirs)" ]; then \
		$(MAKE) -C $(image_dirs) clean; \
	fi

.DEFAULT_GOAL := all

.PHONY: all all_key clean reallyclean
